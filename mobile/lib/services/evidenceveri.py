import os
import hashlib
import sqlite3
import tkinter as tk
from tkinter import filedialog, messagebox
from PIL import Image
import torch
import torchvision.transforms as transforms
import datetime

class EvidenceVerificationSystem:
    def __init__(self):
        # Create upload folder if it doesn't exist
        self.upload_folder = "evidence_verification"
        os.makedirs(self.upload_folder, exist_ok=True)
        
        # Initialize database
        self.conn = self.init_database()
        
        # Initialize GUI
        self.root = tk.Tk()
        self.root.title("Evidence Verification System")
        self.setup_gui()
    
    def init_database(self):
        """Initialize SQLite database connection and create table if needed"""
        conn = sqlite3.connect('evidence.db')
        cursor = conn.cursor()
        
        # Check if the table exists
        cursor.execute("SELECT name FROM sqlite_master WHERE type='table' AND name='evidence'")
        table_exists = cursor.fetchone()
        
        if table_exists:
            # Check if columns exist and add them if they don't
            cursor.execute("PRAGMA table_info(evidence)")
            columns = [column[1] for column in cursor.fetchall()]
            
            if 'filename' not in columns:
                cursor.execute("ALTER TABLE evidence ADD COLUMN filename TEXT")
            
            if 'timestamp' not in columns:
                # Add timestamp column without default value
                cursor.execute("ALTER TABLE evidence ADD COLUMN timestamp TEXT")
                # Update existing records with current time
                current_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
                cursor.execute("UPDATE evidence SET timestamp = ? WHERE timestamp IS NULL", (current_time,))
        else:
            # Create the table with all columns
            cursor.execute("""
                CREATE TABLE IF NOT EXISTS evidence (
                    id INTEGER PRIMARY KEY,
                    hash TEXT UNIQUE,
                    filename TEXT,
                    timestamp TEXT
                )
            """)
        
        conn.commit()
        return conn
    
    def generate_hash(self, image_path):
        """Generate a hash value for an image using PyTorch"""
        try:
            image = Image.open(image_path).convert('RGB')
            transform = transforms.Compose([
                transforms.Resize((224, 224)),
                transforms.ToTensor()
            ])
            img_tensor = transform(image).unsqueeze(0)
            # Use a more efficient approach by computing hash without full conversion to numpy
            # This reduces memory usage for large images
            hash_obj = hashlib.sha256()
            for chunk in img_tensor.flatten():
                hash_obj.update(str(chunk.item()).encode())
            return hash_obj.hexdigest()
        except Exception as e:
            messagebox.showerror("Error", f"Failed to generate hash: {e}")
            return None
    
    def store_evidence(self):
        """Store evidence hash in the database"""
        image_path = filedialog.askopenfilename(
            title="Select an Image to Store",
            filetypes=[("Image Files", "*.png;*.jpg;*.jpeg")]
        )
        
        if not image_path:
            messagebox.showinfo("Info", "No file selected.")
            return False
        
        filename = os.path.basename(image_path)
        evidence_hash = self.generate_hash(image_path)
        
        if evidence_hash is None:
            return False
            
        try:
            current_time = datetime.datetime.now().strftime("%Y-%m-%d %H:%M:%S")
            cursor = self.conn.cursor()
            cursor.execute(
                "INSERT INTO evidence (hash, filename, timestamp) VALUES (?, ?, ?)",
                (evidence_hash, filename, current_time)
            )
            self.conn.commit()
            messagebox.showinfo("Success", f"Evidence stored successfully!\nHash: {evidence_hash[:10]}...")
            
            # Save a copy in the evidence folder
            destination = os.path.join(self.upload_folder, filename)
            Image.open(image_path).save(destination)
            
            return True
        except sqlite3.IntegrityError:
            messagebox.showwarning("Warning", "This evidence already exists in the database!")
            return False
        except Exception as e:
            messagebox.showerror("Error", f"Failed to store evidence: {e}")
            return False
    
    def verify_evidence(self):
        """Verify if the evidence exists in the database"""
        image_path = filedialog.askopenfilename(
            title="Select an Image to Verify",
            filetypes=[("Image Files", "*.png;*.jpg;*.jpeg")]
        )
        
        if not image_path:
            messagebox.showinfo("Info", "No file selected.")
            return
        
        evidence_hash = self.generate_hash(image_path)
        
        if evidence_hash is None:
            return
            
        try:
            cursor = self.conn.cursor()
            cursor.execute("SELECT * FROM evidence WHERE hash = ?", (evidence_hash,))
            result = cursor.fetchone()
            
            if result:
                evidence_id, hash_value = result[0], result[1]
                filename = result[2] if len(result) > 2 and result[2] else "N/A"
                timestamp = result[3] if len(result) > 3 and result[3] else "N/A"
                
                messagebox.showinfo("Verification Result", 
                    f"✅ Evidence is authentic!\n\nID: {evidence_id}\nHash: {hash_value[:10]}...\nOriginal filename: {filename}\nTimestamp: {timestamp}"
                )
            else:
                messagebox.showwarning("Verification Result", "❌ Evidence is not found in the database!")
        except Exception as e:
            messagebox.showerror("Error", f"Failed to verify evidence: {e}")
    
    def list_all_evidence(self):
        """List all evidence in the database"""
        try:
            cursor = self.conn.cursor()
            cursor.execute("SELECT id, hash, filename, timestamp FROM evidence")
            results = cursor.fetchall()
            
            if not results:
                messagebox.showinfo("Evidence List", "No evidence found in the database.")
                return
                
            evidence_window = tk.Toplevel(self.root)
            evidence_window.title("Evidence List")
            evidence_window.geometry("700x400")
            
            # Create scrollable frame with scrollbar
            main_frame = tk.Frame(evidence_window)
            main_frame.pack(fill=tk.BOTH, expand=True, padx=10, pady=10)
            
            canvas = tk.Canvas(main_frame)
            scrollbar = tk.Scrollbar(main_frame, orient=tk.VERTICAL, command=canvas.yview)
            scrollable_frame = tk.Frame(canvas)
            
            scrollable_frame.bind(
                "<Configure>",
                lambda e: canvas.configure(scrollregion=canvas.bbox("all"))
            )
            
            canvas.create_window((0, 0), window=scrollable_frame, anchor="nw")
            canvas.configure(yscrollcommand=scrollbar.set)
            
            canvas.pack(side=tk.LEFT, fill=tk.BOTH, expand=True)
            scrollbar.pack(side=tk.RIGHT, fill=tk.Y)
            
            # Add headers
            headers = ["ID", "Hash", "Filename", "Timestamp"]
            for i, header in enumerate(headers):
                label = tk.Label(scrollable_frame, text=header, font=("Arial", 10, "bold"))
                label.grid(row=0, column=i, sticky="w", padx=5, pady=5)
            
            # Add data
            for i, result in enumerate(results, start=1):
                id_val = result[0] if len(result) > 0 else "N/A"
                hash_val = result[1][:15] + "..." if len(result) > 1 and result[1] else "N/A"
                filename = result[2] if len(result) > 2 and result[2] else "N/A"
                timestamp = result[3] if len(result) > 3 and result[3] else "N/A"
                
                tk.Label(scrollable_frame, text=str(id_val)).grid(row=i, column=0, sticky="w", padx=5, pady=2)
                tk.Label(scrollable_frame, text=hash_val).grid(row=i, column=1, sticky="w", padx=5, pady=2)
                tk.Label(scrollable_frame, text=filename).grid(row=i, column=2, sticky="w", padx=5, pady=2)
                tk.Label(scrollable_frame, text=timestamp).grid(row=i, column=3, sticky="w", padx=5, pady=2)
                
        except Exception as e:
            messagebox.showerror("Error", f"Failed to list evidence: {e}")
    
    def setup_gui(self):
        """Set up the GUI elements"""
        self.root.geometry("400x300")
        self.root.configure(padx=20, pady=20)
        
        # Title
        title_label = tk.Label(self.root, text="Evidence Verification System", font=("Arial", 16, "bold"))
        title_label.pack(pady=20)
        
        # Buttons
        store_btn = tk.Button(self.root, text="Store Evidence", command=self.store_and_verify, width=20, height=2)
        store_btn.pack(pady=10)
        
        verify_btn = tk.Button(self.root, text="Verify Evidence", command=self.verify_evidence, width=20, height=2)
        verify_btn.pack(pady=10)
        
        list_btn = tk.Button(self.root, text="List All Evidence", command=self.list_all_evidence, width=20, height=2)
        list_btn.pack(pady=10)
        
        exit_btn = tk.Button(self.root, text="Exit", command=self.root.quit, width=20, height=2)
        exit_btn.pack(pady=10)
    
    def store_and_verify(self):
        """Store evidence and optionally verify it"""
        if self.store_evidence():
            if messagebox.askyesno("Verification", "Would you like to verify this evidence?"):
                self.verify_evidence()
    
    def run(self):
        """Run the application"""
        self.root.mainloop()
        self.conn.close()


if __name__ == "__main__":
    app = EvidenceVerificationSystem()
    app.run()