module "new_nlb" {
    source = "../module/nlb"
    eip_allocation_ids = module.subnet_eip.eip_allocation_ids
    target_instance_ids = module.sftp_instance.instance_ids
}