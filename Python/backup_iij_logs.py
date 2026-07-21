import os
import json
import boto3
import requests
from datetime import datetime, timedelta
from playwright.sync_api import sync_playwright
from playwright.sync_api import expect


# 環境変数
LOGIN_URL = "https://help.iij.ad.jp/index.cfm?site=iij.admin.web"
LOGIN_USERNAME = ""
LOGIN_PASSWORD = ""
#SERVICE_CODE = "19f457d2111"
#BUCKET_NAME = os.environ["BUCKET_NAME"]


s3 = boto3.client(
    "s3",
    region_name="ap-northeast-1"
)


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

        browser = p.chromium.launch(
            headless=True
        )

        page = browser.new_page(
            viewport={
                "width":1920,
                "height":1080
            }
        )

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

        with page.expect_download() as download_info:
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

            download.save_as(
                "./" + download.suggested_filename
            )

            print("download finished")

            
        #lambda retry設定
        # for retry in range(3):

        #     try:
        #         with page.expect_download(
        #             timeout=60000
        #         ) as download_info:

        #             page.get_by_role(
        #                 "link",
        #                 name=target_date
        #             ).click()

        #         download = download_info.value
        #         break

        #     except Exception as e:

        #         print(
        #             f"retry {retry+1}: {e}"
        #         )

        #         if retry == 2:
        #             raise                        


    # # =========================
    # # 3. Upload S3
    # # =========================

    s3 = boto3.client("s3", region_name="ap-northeast-1")

    # filename = (
    #     f"firewall/"
    #     f"ida76077678-{target_date}.zip"
    # )

    # s3.put_object(
    #     Bucket=BUCKET_NAME,
    #     Key=filename,
    #     Body=zip_data
    # )


    # print(
    #     "upload completed"
    # )


    # return {
    #     "statusCode":200,
    #     "body":"OK"
    # }

lambda_handler({}, {})