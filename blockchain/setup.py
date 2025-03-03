from setuptools import setup, find_packages

setup(
    name="blockchain",
    version="0.1",
    packages=find_packages(),  # Automatically find packages
    install_requires=[
        "web3>=6.0.0",  # Add other dependencies if needed
    ],
)