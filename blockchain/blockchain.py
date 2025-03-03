import json
import logging
from web3 import Web3
from pathlib import Path
from typing import Optional, Dict, Any

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class EvidenceContract:
    def __init__(self, w3: Web3):
        self.w3 = w3
        self.contract = None
        self.account = None
        self._initialize_contract()

    def _initialize_contract(self) -> None:
        try:
            contract_path = Path(__file__).parent / "build" / "contracts" / "EvidenceTracker.json"
            logger.info(f"Loading contract from: {contract_path}")
            
            with open(contract_path) as f:
                contract_json = json.load(f)
            
            # Match Ganache network ID (typically 5777 or 1337)
            network_id = '1337'
            if network_id not in contract_json['networks']:
                raise ValueError(f"Contract not deployed on network ID {network_id}")
            
            contract_address = contract_json['networks'][network_id]['address']
            logger.info(f"Contract address: {contract_address}")
            
            self.contract = self.w3.eth.contract(
                address=contract_address,
                abi=contract_json['abi']
            )
            
            # Use first Ganache account (ensure it's unlocked)
            self.account = self.w3.eth.accounts[0]
            logger.info(f"Using account: {self.account}")
            
        except Exception as e:
            logger.error(f"Contract initialization error: {e}")
            raise

    def create_fir(self, ipfs_hash: str) -> str:
        try:
            logger.info(f"Creating FIR with IPFS hash: {ipfs_hash}")
            
            tx = self.contract.functions.createFIR(ipfs_hash).build_transaction({
                'from': self.account,
                'nonce': self.w3.eth.get_transaction_count(self.account),
                'gas': 2000000,
                'gasPrice': self.w3.to_wei('20', 'gwei')
            })
            
            signed_tx = self.w3.eth.account.sign_transaction(tx, '0x5ed62b4fa552cd46fbf3a89c4d05caad6312e9c0208696930ed1710cd7cc026f')
            tx_hash = self.w3.eth.send_raw_transaction(signed_tx.rawTransaction)
            logger.info(f"FIR created. TX hash: {tx_hash.hex()}")
            return tx_hash.hex()
        
        except Exception as e:
            logger.error(f"Error creating FIR: {e}")
            raise

    # ... (Keep other methods as-is with similar fixes)

    def get_fir(self, fir_id: int) -> Optional[Dict[str, Any]]:
        """
        Retrieve FIR details from the blockchain.

        Args:
            fir_id (int): The ID of the FIR to retrieve.

        Returns:
            Optional[Dict[str, Any]]: A dictionary containing FIR details, or None if not found.
        """
        try:
            logger.info(f"Fetching FIR with ID: {fir_id}")
            
            # Call the contract function
            fir = self.contract.functions.getFIR(fir_id).call()
            
            if not fir:
                logger.warning(f"FIR with ID {fir_id} not found")
                return None
            
            # Convert FIR tuple to a dictionary
            fir_details = {
                'ipfsHash': fir[0],
                'officer': fir[1],
                'timestamp': fir[2],
                'isOpen': fir[3]
            }
            
            logger.info(f"FIR details: {fir_details}")
            return fir_details
        
        except Exception as e:
            logger.error(f"Error fetching FIR: {e}")
            return None

    def add_evidence(self, case_id: int, ipfs_hash: str) -> str:
        """
        Add evidence to a case on the blockchain.

        Args:
            case_id (int): The ID of the case to add evidence to.
            ipfs_hash (str): The IPFS hash of the evidence document.

        Returns:
            str: The transaction hash of the added evidence.
        """
        try:
            logger.info(f"Adding evidence to case {case_id} with IPFS hash: {ipfs_hash}")
            
            # Build the transaction
            tx = self.contract.functions.addEvidence(case_id, ipfs_hash).buildTransaction({
                'from': self.account,
                'nonce': self.w3.eth.get_transaction_count(self.account),
                'gas': 2000000,  # Adjust gas limit as needed
                'gasPrice': self.w3.toWei('20', 'gwei')  # Adjust gas price as needed
            })
            
            # Sign the transaction
            signed_tx = self.w3.eth.account.sign_transaction(tx, private_key='0x5ed62b4fa552cd46fbf3a89c4d05caad6312e9c0208696930ed1710cd7cc026f')
            
            # Send the transaction
            tx_hash = self.w3.eth.send_raw_transaction(signed_tx.rawTransaction)
            logger.info(f"Evidence added successfully. Transaction hash: {tx_hash.hex()}")
            
            return tx_hash.hex()
        
        except Exception as e:
            logger.error(f"Error adding evidence: {e}")
            raise

    def get_evidence(self, evidence_id: int) -> Optional[Dict[str, Any]]:
        """
        Retrieve evidence details from the blockchain.

        Args:
            evidence_id (int): The ID of the evidence to retrieve.

        Returns:
            Optional[Dict[str, Any]]: A dictionary containing evidence details, or None if not found.
        """
        try:
            logger.info(f"Fetching evidence with ID: {evidence_id}")
            
            # Call the contract function
            evidence = self.contract.functions.getEvidence(evidence_id).call()
            
            if not evidence:
                logger.warning(f"Evidence with ID {evidence_id} not found")
                return None
            
            # Convert evidence tuple to a dictionary
            evidence_details = {
                'ipfsHash': evidence[0],
                'caseId': evidence[1],
                'timestamp': evidence[2]
            }
            
            logger.info(f"Evidence details: {evidence_details}")
            return evidence_details
        
        except Exception as e:
            logger.error(f"Error fetching evidence: {e}")
            return None