import urllib3
from urllib.parse import urljoin
from datetime import datetime, timedelta
from zoneinfo import ZoneInfo
import os
import boto3


USERNAME = os.getenv("IIJ_USERNAME")
PASSWORD = os.getenv("IIJ_PASSWORD")

S3_BUCKET_NAME = os.getenv("S3_BUCKET_NAME")
S3_PREFIX = os.getenv("S3_PREFIX", "iij-log")


LOGIN_URL = "https://login.iij.ad.jp/default/login.cgi"

ZIP_URL_TEMPLATE = (
    "https://help-gate.iij.ad.jp/"
    "service/yf/yf2066969/log/yg2066976/{date}.zip"
)


http = urllib3.PoolManager(
    cert_reqs="CERT_REQUIRED"
)

s3 = boto3.client(
    "s3",
    region_name="ap-northeast-1"
)


cookies = {}


def update_cookie(response):

    set_cookie = response.headers.get_all("Set-Cookie")

    if not set_cookie:
        return

    for item in set_cookie:

        parts = item.split(";")[0]

        name, value = parts.split("=", 1)

        cookies[name] = value



def cookie_header():

    return "; ".join(
        f"{k}={v}"
        for k, v in cookies.items()
    )



def lambda_handler(event, context):

    jst = ZoneInfo("Asia/Tokyo")

    target_date = (
        datetime.now(jst)
        - timedelta(days=1)
    )

    date_str = target_date.strftime("%Y%m%d")


    zip_url = ZIP_URL_TEMPLATE.format(
        date=date_str
    )


    print("ZIP:", zip_url)


    # =====================
    # Login
    # =====================

    login_body = {
        "username": USERNAME,
        "password": PASSWORD,
        "site": "iij.zero.gate.www"
    }


    r1 = http.request(
        "POST",
        LOGIN_URL,
        fields=login_body,
        redirect=False,
        headers={
            "User-Agent":
            "Mozilla/5.0"
        }
    )


    print("Login:", r1.status)


    update_cookie(r1)


    print("Cookie:", cookies)


    # =====================
    # Redirect 1
    # =====================

    location = r1.headers.get("Location")

    r2 = http.request(
        "GET",
        location,
        redirect=False,
        headers={
            "Cookie": cookie_header(),
            "User-Agent":
            "Mozilla/5.0"
        }
    )


    print(
        "Redirect:",
        r2.status,
        r2.headers.get("Location")
    )


    update_cookie(r2)


    # =====================
    # Download ZIP
    # =====================

    r3 = http.request(
        "GET",
        zip_url,
        redirect=False,
        headers={
            "Cookie": cookie_header(),
            "User-Agent":
            "Mozilla/5.0"
        }
    )


    print(
        "Download:",
        r3.status,
        r3.headers.get("Content-Type")
    )


    if (
        r3.status == 200
        and "zip" in
        r3.headers.get(
            "Content-Type",
            ""
        )
    ):

        file = f"/tmp/{date_str}.zip"


        with open(file, "wb") as f:
            f.write(r3.data)


        print("Saved:", file)


        s3.upload_file(
            file,
            S3_BUCKET_NAME,
            f"{S3_PREFIX}/{date_str}.zip"
        )


        print("S3 upload success")


        return {
            "status": "success"
        }


    else:

        print(r3.headers)

        return {
            "status": "failed"
        }