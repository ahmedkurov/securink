# SecureInk - Blockchain-Based Evidence Management System

SecureInk is a comprehensive evidence management system that leverages blockchain technology to ensure the integrity and immutability of digital evidence. The system provides a secure, transparent, and verifiable way to store and manage digital evidence.

## 🌟 Features

- **Blockchain Integration**: Secure storage of evidence hashes on the blockchain
- **IPFS Storage**: Distributed storage of evidence files
- **Mobile App**: Cross-platform mobile application for evidence capture and management
- **Web Backend**: RESTful API for evidence management
- **Evidence Verification**: Tools for verifying evidence integrity
- **Smart Contracts**: Automated evidence management and verification

## 🏗️ Architecture

The project consists of several components:

- **Blockchain Module**: Smart contracts and blockchain integration
- **Backend API**: FastAPI-based REST API
- **Mobile App**: Flutter-based cross-platform application
- **Evidence Verification**: Tools for verifying evidence integrity
- **IPFS Integration**: Distributed file storage

## 🚀 Getting Started

### Prerequisites

- Node.js (v14 or higher)
- Python (3.8 or higher)
- Flutter SDK
- Ganache (for local blockchain)
- IPFS daemon

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/ahmedkurov/securink.git
   cd securink
   ```

2. **Setup Blockchain**
   ```bash
   cd blockchain
   npm install
   # Configure .env file with your settings
   truffle migrate
   ```

3. **Setup Backend**
   ```bash
   cd backend
   python -m venv venv
   source venv/bin/activate  # On Windows: venv\Scripts\activate
   pip install -r requirements.txt
   # Configure .env file with your settings
   ```

4. **Setup Mobile App**
   ```bash
   cd mobile
   flutter pub get
   # Configure environment variables
   ```

### Configuration

1. Create `.env` files in respective directories based on `.env.example`
2. Configure blockchain network settings
3. Set up IPFS daemon
4. Configure mobile app endpoints

## 🛠️ Development

### Running the Backend
```bash
cd backend
uvicorn main:app --reload
```

### Running the Mobile App
```bash
cd mobile
flutter run
```

### Testing Smart Contracts
```bash
cd blockchain
truffle test
```

## 🔒 Security

- All sensitive information is stored in environment variables
- Private keys and API keys are never committed to the repository
- Evidence integrity is verified through blockchain hashes
- IPFS ensures distributed and tamper-proof storage

## 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📞 Support

For support, please open an issue in the GitHub repository or contact the maintainers.

## 🙏 Acknowledgments

- Ethereum blockchain
- IPFS
- FastAPI
- Flutter
- Truffle Suite