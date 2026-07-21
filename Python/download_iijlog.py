import os
import json
import boto3
import requests
from datetime import datetime, timedelta

LOGIN_URL = "https://help.iij.ad.jp/index.cfm"
LOGIN_USERNAME = ""
LOGIN_PASSWORD = ""
SERVICE_CODE = ""

def login_to_iij():
    session = requests.Session()
    login_payload = {
        "username": LOGIN_USERNAME,
        "password": LOGIN_PASSWORD
    }
    print(f"Start login")
    response = session.post(LOGIN_URL, data=login_payload)
    if response.status_code == 200:
        print("Login successful")
        return session
    else:
        print("Login failed")
        return None
    
def download_logs(session, service_code):
    target_date = (datetime.now() - timedelta(days=1)).strftime("%Y-%m-%d")  
    logs_url = (
        "https://portal.iij-omnibus.jp/api/v1/efw_module/log_dl"
        f"?serviceCode={SERVICE_CODE}"
        f"&date={target_date}"
    )
    print(f"Downloading logs from {logs_url}")

    response = session.get(logs_url)
    if response.status_code == 200:
        logs = response.json()
        return logs
    else:
        print("Failed to download logs")
        return None
    
download_logs(login_to_iij(), SERVICE_CODE)