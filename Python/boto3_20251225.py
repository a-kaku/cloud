from pathlib import Path
import json
import boto3

s3 = boto3.client("s3")

def upload_file (file_path):
    path = Path(file_path)
    mes = path.read_text()
    if mes:
        json_file = json.dumps({'content':mes})
        print(f"The file's content is {json_file}")
    else:
        print("The file is empty.")

upload_file('C:/Users/m-kaku/Code_repository/Python/file_test.py')