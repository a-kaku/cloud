import os
import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

# 模拟 ZabbixMetric
class MockZabbixMetric:
    def __init__(self, host, key, value):
        self.host = host
        self.key = key
        self.value = value
    def __repr__(self):
        return f"MockZabbixMetric(host={self.host}, key={self.key}, value={self.value})"

# 模拟 ZabbixSender
class MockZabbixSender:
    def __init__(self, server, port):
        self.server = server
        self.port = port
    def send(self, metrics):
        logger.info(f"Simulated sending to {self.server}:{self.port}")
        for m in metrics:
            logger.info(m)
        return {"failed": 0, "processed": len(metrics)}

# Lambda handler
def lambda_handler(event, context):
    try:
        logger.info("Received event:")
        logger.info(event)

        zabbix_host = os.getenv('ZBXHOST', 'test-host')
        zabbix_item_key = os.getenv('ZBXITEMKEY', 'test.item.key')
        zabbix_server = os.getenv('ZBXSRV', '127.0.0.1')
        zabbix_port = int(os.getenv('ZBXPORT', '10051'))

        # 使用 MockZabbixMetric 替代 pyzabbix
        zabbix_event_data = [MockZabbixMetric(zabbix_host, zabbix_item_key, json.dumps(event))]
        zabbix_sender = MockZabbixSender(zabbix_server, zabbix_port)
        response = zabbix_sender.send(zabbix_event_data)

        logger.info("Send response:")
        logger.info(response)

    except Exception as e:
        logger.error("Error occurred: {}".format(e))

# 本地测试
if __name__ == "__main__":
    os.environ['ZBXHOST'] = 'my-test-host'
    os.environ['ZBXITEMKEY'] = 'my.test.key'
    os.environ['ZBXSRV'] = '10.200.0.51'
    os.environ['ZBXPORT'] = '10051'

    mock_event = {
        "detail-type": "EC2 Instance State-change Notification",
        "detail": {
            "instance-id": "i-1234567890abcdef0",
            "state": "running"
        }
    }

    lambda_handler(mock_event, None)
