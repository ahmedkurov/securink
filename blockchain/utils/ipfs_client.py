import requests
from typing import Optional, Union
from pathlib import Path
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class IPFSClient:
    def __init__(self, api_url: str = 'http://127.0.0.1:5001/api/v0'):
        self.api_url = api_url
        self._verify_connection()

    def _verify_connection(self) -> None:
        try:
            response = requests.post(f'{self.api_url}/id', timeout=5)
            response.raise_for_status()
            peer_id = response.json().get('ID', 'Unknown')
            logger.info(f"Connected to IPFS node (Peer ID: {peer_id})")
        except Exception as e:
            logger.error(f"IPFS connection failed: {str(e)}")
            raise

    def add(self, content: Union[bytes, str, Path]) -> Optional[str]:
        try:
            if isinstance(content, Path):
                if not content.is_file():
                    raise ValueError(f"Invalid file: {content}")
                with content.open('rb') as f:
                    files = {'file': f}
                    response = requests.post(f'{self.api_url}/add', files=files, timeout=15)
            else:
                if isinstance(content, str):
                    content = content.encode('utf-8')
                files = {'file': ('content', content)}
                response = requests.post(f'{self.api_url}/add', files=files, timeout=15)

            response.raise_for_status()
            return response.json()['Hash']
        except Exception as e:
            logger.error(f"IPFS upload failed: {str(e)}")
            return None

    

    def cat(self, cid: str) -> Optional[bytes]:
        """Retrieve content from IPFS by CID"""
        try:
            response = requests.post(
                f'{self.api_url}/cat',
                params={'arg': cid},
                timeout=10
            )
            response.raise_for_status()
            logger.info(f"Successfully retrieved content for CID: {cid}")
            return response.content
        except Exception as e:
            logger.error(f"IPFS cat error for CID {cid}: {str(e)}")
            return None

    def is_connected(self) -> bool:
        """Check if connection to IPFS node is active"""
        try:
            response = requests.post(f'{self.api_url}/id', timeout=2)
            return response.status_code == 200
        except Exception:
            return False

    def pin(self, cid: str) -> bool:
        """Pin content to IPFS node"""
        try:
            response = requests.post(
                f'{self.api_url}/pin/add',
                params={'arg': cid},
                timeout=5
            )
            response.raise_for_status()
            logger.info(f"Pinned content with CID: {cid}")
            return True
        except Exception as e:
            logger.error(f"IPFS pin error for CID {cid}: {str(e)}")
            return False