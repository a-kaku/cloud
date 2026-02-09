import boto3

def stop_ec2(InstanceIds):
    """Stops an Instance."""

    aws_region = 'ap-northeast-1'
    ec2 = boto3.client('ec2', region_name=aws_region)
    try:
        response = ec2.stop_instances(InstanceIds=InstanceIds)
    except Exception as e:
        print(f"Reboot failed: {e}")

def start_ec2(InstanceIds):
    """Starts an instance."""
    ec2 = boto3.client('ec2')
    try:
        response = ec2.start_instances(InstanceIds=InstanceIds)
    except Exception as e:
        print(f"Start instance failed: {e}")

instance_ids = ['i-0da38292f63136e56']
# stop_ec2(instance_ids)
start_ec2(instance_ids)
