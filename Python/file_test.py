from pathlib import Path
import csv

def read_csv(file_path):
    with open(file_path,mode='r') as csv_file:
        csv_reader = csv.reader(csv_file)
        data = [row for row in csv_reader]
        print(f"Read {len(data)} rows from {file_path}")

received_path = input("Enter the path to the CSV file: ")
path = Path(received_path)
read_csv(path)