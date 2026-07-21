import os
import json
import boto3
import requests
from datetime import datetime, timedelta
from playwright.sync_api import sync_playwright
from playwright.sync_api import expect
import subprocess

# 環境変数
LOGIN_URL = os.environ["LOGIN_URL"]
LOGIN_USERNAME = os.environ["LOGIN_USERNAME"]
LOGIN_PASSWORD = os.environ["LOGIN_PASSWORD"]
BUCKET_NAME = os.environ["BUCKET_NAME"]
S3_PREFIX = os.environ["S3_PREFIX"]

def lambda_handler(event, context):

    print("start lambda")

    # 昨日の日付
    yesterday = datetime.now() - timedelta(days=1)
    target_date = f"{yesterday.month}/{yesterday.day}"

    print(f"download date: {target_date}")


    # =========================
    # 1. Login
    # =========================

    with sync_playwright() as p:

        print("Launching browser...")

        browser = p.chromium.launch(
            headless=True,
            args=[
                # "--no-sandbox",
                # "--disable-setuid-sandbox",
                # "--disable-dev-shm-usage",
                # "--disable-gpu",
                # "--single-process",
                # "--no-zygote"
                "--no-sandbox",
                "--disable-setuid-sandbox",
                "--disable-dev-shm-usage",
                "--disable-gpu",
                "--single-process",
                "--no-zygote",
                "--disable-accelerated-2d-canvas",
                "--disable-accelerated-jpeg-decoding",
                "--disable-accelerated-mjpeg-decode",
                "--disable-accelerated-video-decode",
                "--disable-background-timer-throttling",
                "--disable-backgrounding-occluded-windows",
                "--disable-breakpad",
                "--disable-component-extensions-with-background-pages",
                "--disable-extensions",
                "--disable-features=IsolateOrigins,site-per-process",
                "--disable-hang-monitor",
                "--disable-ipc-flooding-protection",
                "--disable-popup-blocking",
                "--disable-prompt-on-repost",
                "--disable-renderer-backgrounding",
                "--disable-sync",
                "--disable-web-security",
                "--force-color-profile=srgb",
                "--metrics-recording-only",
                "--no-first-run",
                "--password-store=basic",
                "--use-mock-keychain",
                "--disable-features=TranslateUI",     
                "--disable-ipc-flooding-protection",  
                "--disable-background-networking",    
                "--disable-default-apps",              
                "--disable-sync-preferences"                 
            ]            
        )

        print(browser.is_connected())

        chrome_path = p.chromium.executable_path
        print(f"Chromium path: {chrome_path}")
        result = subprocess.run([chrome_path, "--version"], capture_output=True, text=True)
        print(f"Chromium version: {result.stdout}")
        print(f"Chromium stderr: {result.stderr}")


        browser_context = browser.new_context(
            viewport={
                "width":1920,
                "height":1080
            },
            accept_downloads=True,
            ignore_https_errors=True
        )

        page = browser_context.new_page()

        print("Page created")

        page.goto(
            LOGIN_URL,
            wait_until="networkidle"
        )

        page.fill(
            "#usernameLogin",
            LOGIN_USERNAME
        )

        page.fill(
            "#passwordLogin",
            LOGIN_PASSWORD
        )

        page.get_by_role(
            "button",
            name="ログイン"
        ).click(
            no_wait_after=True
        )

        # ログイン待機
        page.wait_for_timeout(5000)


        page.goto(
            "https://help.iij.ad.jp/admin/index.cfm",
            wait_until="networkidle"
        )

        page.wait_for_timeout(5000)

    # =========================
    # 2. Download
    # =========================

        # ログイン後、HOME画面からログ画面まで遷移のためのクリック操作を順番に実行する
        # 1. サービスの設定と管理
        page.get_by_role(
            "link",
            name="サービスの設定と管理"
        ).click()

        page.wait_for_timeout(2000)


        # 2. IIJマネージドファイアウォール
        page.get_by_role(
            "link",
            name="IIJマネージドファイアウォール",
        ).click()

        page.wait_for_timeout(2000)


        # 3. 「ログのダウンロード」
        page.get_by_role(
            "link",
            name="ログのダウンロード",
        ).click()

        page.wait_for_timeout(2000)

        # 4. ダウンロード対象の日付のリンクをクリックしてダウンロードする 
        for retry in range(3):
            try:
                with page.expect_download(timeout=10000) as download_info:
                    page.get_by_role(
                        "link",
                        name=target_date
                    ).click()        

                    page.wait_for_load_state(
                        "networkidle"
                    )

                    download = download_info.value

                    print("download filename:")
                    print(download.suggested_filename)

                    download_path = f"/tmp/{download.suggested_filename}"
                    download.save_as(
                        download_path
                    )

                    print("download finished")

                    break

            except Exception as e:
                print(
                    f"retry {retry+1}: {e}"
                )

                if retry == 2:
                    raise


    # # =========================
    # # 3. Upload S3
    # # =========================

    s3 = boto3.client("s3", region_name="ap-northeast-1")

    s3.upload_file(download_path, BUCKET_NAME,f"{S3_PREFIX}/{download.suggested_filename}")

    os.remove(download_path)

    print(
        "upload completed"
    )

    return {
        "statusCode":200,
        "body":"OK"
    }
