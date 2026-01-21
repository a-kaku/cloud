import os
from pyzabbix import ZabbixAPI
from datetime import datetime, timezone, timedelta

Zabbix_URL = "http://zabbix.h21.private/zabbix"
Zabbix_User = os.environ["ZABBIX_USER"]
Zabbix_Password = os.environ["ZABBIX_PASSWORD"]

def main():
    zapi = ZabbixAPI(Zabbix_URL)
    zapi.login(Zabbix_User, Zabbix_Password)
    print("Connected to Zabbix API Version %s" % zapi.api_version())

    # 猶予期間を設定
    GRACE_PERIOD_DAYS = 7
    now_ts = int(datetime.now(tz=timezone.utc).timestamp())
    cutoff_ts = int((datetime.now(tz=timezone.utc) - timedelta(days=GRACE_PERIOD_DAYS)).timestamp())

    maintenance_list = zapi.maintenance.get(
        output=["maintenanceid", "name", "active_since", "active_till"]
    )
    deleted_count = 0
    for m in maintenance_list:
        active_till = int(m["active_till"])
        # 終了から猶予期間以上経過したものだけ削除
        if active_till < cutoff_ts:
            zapi.maintenance.delete(m["maintenanceid"])
            print(f"Deleted maintenance: {m['name']} (ID: {m['maintenanceid']})")
            deleted_count += 1
    print("The script has completed.")

main()