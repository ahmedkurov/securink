async function uploadEvidence() {
    const fileInput = document.getElementById('fileInput');
    if (!fileInput.files[0]) {
        showError('Please select a file!');
        return;
    }

    try {
        const formData = new FormData();
        formData.append('file', fileInput.files[0]);

        const response = await fetch('http://localhost:8000/create-fir', {
            method: 'POST',
            body: formData
        });

        if (!response.ok) throw await response.json();
        
        const data = await response.json();
        document.getElementById('uploadResult').innerHTML = `
            <div class="alert alert-success mt-3">
                ✅ Upload successful!<br>
                TX Hash: <code>${data.tx_hash}</code><br>
                IPFS CID: <code>${data.ipfs_hash}</code>
            </div>
        `;
        
    } catch (error) {
        showError(`Upload failed: ${error.detail || error.message}`);
    }
}