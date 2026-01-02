import os
import sys
import filecmp
import shutil

def sync_folders(folder1, folder2):
    for filename in os.listdir(folder1):
        file1 = os.path.join(folder1, filename)
        file2 = os.path.join(folder2, filename)
        
        # Skip directories and non-regular files
        if not os.path.isfile(file1):
            continue
            
        if os.path.exists(file2):
            # Compare file contents
            if not filecmp.cmp(file1, file2, shallow=False):
                shutil.copy2(file2, file1)
                print(f"Replaced: {filename}")
        else:
            print(f"Not found in {folder2}: {filename}")

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python sync_images.py <folder1> <folder2>")
        sys.exit(1)
        
    folder1 = sys.argv[1]
    folder2 = sys.argv[2]
    
    if not os.path.isdir(folder1) or not os.path.isdir(folder2):
        print("Error: Both arguments must be valid directories")
        sys.exit(1)
    
    sync_folders(folder1, folder2)
    print("Operation completed")