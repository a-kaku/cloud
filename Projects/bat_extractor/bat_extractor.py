import os
import csv
from pathlib import Path
import sys

if getattr(sys, 'frozen', False):
    # exe
    folder = Path(sys.executable).resolve().parent
else:
    # python
    folder = Path(__file__).resolve().parent

output = "cns_result.csv"

results = []

for filename in os.listdir(folder):

    if filename.endswith(".bat"):

        filepath = os.path.join(folder, filename)

        with open(filepath, encoding="cp932") as f:

            for line in f:
                line = line.strip()

                if line.startswith("set CNS"):

                    # set CNS_xxx=value の value 部分を取得
                    if "=" in line:
                        key, value = line.split("=", 1)

                        results.append([
                            filename,
                            key.strip(),
                            value.strip()
                        ])


with open(output, "w", newline="", encoding="utf-8-sig") as f:

    writer = csv.writer(f)

    writer.writerow([
        "bat_file",
        "CNS_key",
        "value"
    ])

    writer.writerows(results)


print(f"Output: {output}")

# ======================
# EXE作成コマンド（PowerShell）
#
# py -m PyInstaller --onefile extract.py
#
# 生成された実行ファイル：
#   dist\extract.exe
#
# プログラムを修正した場合は、上記コマンドを再実行してください。
# ======================