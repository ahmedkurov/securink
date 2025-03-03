import sys
import os
import logging
from pathlib import Path
from fastapi import FastAPI, File, UploadFile, HTTPException
from fastapi.middleware.cors import CORSMiddleware
from fastapi.staticfiles import StaticFiles
from web3 import Web3

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Path configuration
blockchain_path = str(Path(__file__).resolve().parents[2] / "blockchain")
utils_path = str(Path(__file__).resolve().parents[1] / "utils")
sys.path.extend([blockchain_path, utils_path])

try:
    from blockchain import EvidenceContract
    from utils.ipfs_client import IPFSClient
except ImportError as e:
    logger.error(f"Import error: {e}")
    raise

app = FastAPI()

# Initialize Web3
try:
    w3 = Web3(Web3.HTTPProvider('http://localhost:7545'))
    assert w3.is_connected(), "Ganache connection failed"
except Exception as e:
    logger.error(f"Web3 error: {e}")
    raise

# Initialize components
try:
    contract = EvidenceContract(w3)
    ipfs = IPFSClient()
    logger.info("Blockchain and IPFS initialized")
except Exception as e:
    logger.error(f"Initialization failed: {e}")
    raise

# CORS configuration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_methods=["*"],
    allow_headers=["*"],
)

# Serve frontend
app.mount("/static", StaticFiles(directory=Path(__file__).parent / "static"), name="static")

@app.post("/create-fir")
async def create_fir(file: UploadFile = File(...)):
    try:
        content = await file.read()
        if not content:
            raise HTTPException(400, "Empty file")
        
        ipfs_hash = ipfs.add(content)
        if not ipfs_hash:
            raise HTTPException(500, "IPFS upload failed")
        
        tx_hash = contract.create_fir(ipfs_hash)
        return {"tx_hash": tx_hash, "ipfs_hash": ipfs_hash}
    
    except Exception as e:
        logger.error(f"Upload failed: {str(e)}")
        raise HTTPException(500, str(e))



@app.get("/fir/{fir_id}")
async def get_fir(fir_id: int):
    try:
        logger.info(f"Fetching FIR with ID: {fir_id}")
        fir = contract.get_fir(fir_id)
        if not fir:
            raise HTTPException(status_code=404, detail="FIR not found")

        logger.info("Retrieving from IPFS...")
        content = ipfs.cat(fir['ipfsHash'])
        logger.info("IPFS content retrieved successfully")

        return {
            "id": fir_id,
            "content": content.decode(),
            "timestamp": fir['timestamp'],
            "officer": fir['officer'],
            "status": "open" if fir['isOpen'] else "closed"
        }
    except Exception as e:
        logger.error(f"Error fetching FIR: {str(e)}")
        raise HTTPException(status_code=500, detail=str(e))

@app.get("/health")
async def health_check():
    status = {
        "web3_connected": w3.is_connected(),
        "ipfs_connected": ipfs.is_connected(),
        "latest_block": w3.eth.block_number,
        "contract_address": contract.contract.address if contract else None
    }
    logger.info(f"Health check: {status}")
    return status

# Debug: Verify app is fully loaded
logger.info("FastAPI app loaded successfully. Ready to accept requests!")
logger.info(f"Available routes: {[route.path for route in app.routes]}")
