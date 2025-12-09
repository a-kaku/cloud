from pathlib import Path
import csv

def read_csv(file_path):
    with open(file_path,mode='r') as csv_file:
        csv_reader = csv.reader(csv_file)
        data = [row for row in csv_reader]
        print(f"Read {len(data)} rows from {file_path}")

path = Path("C:/Users/m-kaku/Desktop/対応案件/Pleasanter/会社コード、activedirectoryチェック追加用/13_会社アルファベット略語_2025_09_30 10_24_47.Csv")
read_csv(path)