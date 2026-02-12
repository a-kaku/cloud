module "new_nlb" {
    source = "../module/nlb"
    eip_allocation_ids = module.eip.eip_allocation_ids
    target_instance_ids = {
      sftp01 = aws_instance.sftp_instance["sftp-01"].id
      sftp02 = aws_instance.sftp_instance["sftp-02"].id
    }
}