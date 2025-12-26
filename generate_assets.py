import os
import random
from reportlab.pdfgen import canvas
from PIL import Image
import numpy as np

ASSETS_DIR = "tutorial_assets"
os.makedirs(ASSETS_DIR, exist_ok=True)

# 1. Generate PDF
pdf_path = os.path.join(ASSETS_DIR, "CONFIDENTIAL.pdf")
c = canvas.Canvas(pdf_path)
c.setFont("Helvetica-Bold", 40)
c.drawString(100, 750, "TOP SECRET DOCTRINE")
c.setFont("Helvetica", 12)
c.drawString(100, 700, "This is a confidential PDF document generated for")
c.drawString(100, 680, "Radiohead Vault steganography demonstration.")
c.drawString(100, 600, "CONFIDENTIAL ID: " + str(random.randint(10000, 99999)))
c.save()
print(f"Generated {pdf_path}")

# 2. Generate Cover Image (Noisy Gradient)
img_path = os.path.join(ASSETS_DIR, "cover.png")
width, height = 1024, 1024
array = np.random.randint(0, 255, (height, width, 3), dtype=np.uint8)
img = Image.fromarray(array)
img.save(img_path)
print(f"Generated {img_path}")
