# lib/data/helpers/file_utils.py

import os

def ensure_folder(path):
    os.makedirs(path, exist_ok=True)
