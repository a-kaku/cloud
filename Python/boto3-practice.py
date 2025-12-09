import boto3

s3 = boto3.client('s3')
s3.upload_file(
    Filename = 'boto3-practice.py',
    Bucket = 'akira.bucket',
    Key = '/cloud-script/boto3-practice.py'
)

buckets_list = s3.list_buckets()
print(buckets_list)
print('You have succesfully saved the file.')