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

        def log_request(request):
            if "log_dl" in request.url:
                print("===== REQUEST =====")
                print(request.method)
                print(request.url)
                print(request.headers)

        page.on(
            "request",
            log_request
        )

        # inputs = page.locator("input")

        # print(
        #     "input count:",
        #     inputs.count()
        # )

        # for i in range(inputs.count()):
        #     print(
        #         inputs.nth(i).get_attribute("id"),
        #         inputs.nth(i).get_attribute("name"),
        #         inputs.nth(i).get_attribute("type")
        #     )


        # page.screenshot(
        #     path="login_page.png",
        #     full_page=True
        # )

        # print(page.url)
        # print(page.title())

        print("input login")


        page.fill(
            "#usernameLogin",
            LOGIN_USERNAME
        )

        page.fill(
            "#passwordLogin",
            LOGIN_PASSWORD
        )


        buttons = page.locator("button")

        print("button count:", buttons.count())

        for i in range(buttons.count()):
            print(
                i,
                buttons.nth(i).inner_text(),
                buttons.nth(i).get_attribute("class"),
                buttons.nth(i).get_attribute("id")
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


        # print("portal:")
        # print(page.url)
        # print(page.title())

        # # Cookie取得
        # cookies = page.context.cookies()


        # cookie_header = "; ".join(
        #     [
        #         f"{c['name']}={c['value']}"
        #         for c in cookies
        #     ]
        # )


        # print("===== LOGIN RESULT =====")
        # print("URL:", page.url)
        # print("TITLE:", page.title())


        # cookies = page.context.cookies()

        # print("===== COOKIES =====")
        # for c in cookies:
        #     print(
        #         c["name"],
        #         "=",
        #         c["value"][:30],
        #         "domain=",
        #         c["domain"]
        #     )


        # session_storage = page.evaluate("""
        # () => {
        #     let data = {};
        #     for (let i = 0; i < sessionStorage.length; i++) {
        #         let key = sessionStorage.key(i);
        #         data[key] = sessionStorage.getItem(key);
        #     }
        #     return data;
        # }
        # """)

        # print("===== SESSION STORAGE =====")
        # print(session_storage)


        # local_storage = page.evaluate("""
        # () => {
        #     let data = {};
        #     for (let i = 0; i < localStorage.length; i++) {
        #         let key = localStorage.key(i);
        #         data[key] = localStorage.getItem(key);
        #     }
        #     return data;
        # }
        # """)

        # print("===== LOCAL STORAGE =====")
        # print(local_storage)


    # =========================
    # 2. Download
    # =========================
        print("after login:")
        print(page.url)
        print(page.title())


        # page.screenshot(
        #     path="home_debug.png",
        #     full_page=True
        # )

        page.get_by_role(
            "link",
            name="サービスの設定と管理"
        ).click()

        page.wait_for_timeout(2000)


        # 3. Service Management
        page.get_by_role(
            "link",
            name="IIJマネージドファイアウォール",
        ).click()

        page.wait_for_timeout(2000)


        # 4. 「ログのダウンロード」
        page.get_by_role(
            "link",
            name="ログのダウンロード",
        ).click()

        page.wait_for_timeout(2000)

        # 5. 
        print(page.url)

        print(
            page.get_by_role(
                "link",
                name=target_date
            ).count()
        )

        with page.expect_download() as download_info:
            page.get_by_role(
                "link",
                name=target_date
            ).click()        

            page.wait_for_load_state(
                "networkidle"
            )

            # print(
            #     page.locator("body").inner_text()
            # )

            print("Over view log download page")


            download = download_info.value


            download = download_info.value


            print("download filename:")
            print(download.suggested_filename)


            download.save_as(
                "./" + download.suggested_filename
            )


            print("download finished")            



# print("LOG PAGE:")
# print(page.url)


# page.screenshot(
#     path="logs_page.png",
#     full_page=True
# )




        # download_url = (
        #     "https://help.iij.ad.jp/admin/service/setting/yf/menu/logs/index.cfm?"
        #     f"&serviceSeq={SERVICE_CODE}"
        #     f"&date={target_date}"
        # )


        # print(download_url)

        # page.goto(
        #     "https://help.iij.ad.jp/admin/service/setting/yf/menu/logs/index.cfm?&serviceSeq=19f457d2111",
        #     wait_until="networkidle"
        # )


        # print("log page")
        # print(page.url)


        # page.screenshot(
        #     path="logs_page.png",
        #     full_page=True
        # )


        # ======================
        # 查找下载按钮
        # ======================

        # buttons = page.locator("button")

        # print("button count", buttons.count())

        # for i in range(buttons.count()):
        #     print(
        #         i,
        #         buttons.nth(i).inner_text()
        #     )

        # headers = {

        #     # 注意:
        #     # 実際のtoken名はsessionStorage確認必要
        #     "Authorization":
        #         "Bearer " + json.dumps(session_storage),

        #     "Cookie":
        #         cookie_header
        # }


        # response = requests.get(
        #     download_url,
        #     headers=headers,
        #     timeout=60
        # )

        # response = requests.get(
        #     download_url,
        #     headers=headers,
        #     timeout=60
        # )

        # print("status:", response.status_code)

        # if response.status_code != 200:
        #     print(response.text)
        #     return


        # response.raise_for_status()


        # zip_data = response.content


        # print(
        #     f"download size: {len(zip_data)} bytes"
        # )

        # user_info = json.loads(
        #     session_storage["user"]
        # )

        # csrf_token = user_info["csrfToken"]


        # headers = {
        #     "X-Csrftoken": csrf_token,
        #     "Referer": "https://portal.iij-omnibus.jp/ui/",
        #     "Accept": "application/json, text/plain, */*",
        #     "User-Agent": "Mozilla/5.0",
        # }


        # cookie_dict = {
        #     c["name"]: c["value"]
        #     for c in cookies
        # }


        # response = page.request.get(
        #     download_url,
        #     headers=headers
        # )

        # print("status:", response.status)

        # if response.status != 200:
        #     print(response.text())
        #     print("status:", response.status)

        #     print("headers:")
        #     print(response.headers)

        #     print("body:")
        #     print(repr(response.text()))

        # zip_data = response.body()

        # print(
        #     f"download size: {len(zip_data)} bytes"
        # )


        # print("status:", response.status)

        # if response.status != 200:
        #     print(response.text)

        #     print("status:", response.status)

        #     print("headers:")
        #     print(response.headers)

        #     print("body:")
        #     print(repr(response.text()))

        # page.screenshot(
        # path="logs.png",
        # full_page=True
        # )


    # # =========================
    # # 3. Upload S3
    # # =========================


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