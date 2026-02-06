module "new_nlb" {
    source = "../module/nlb"
    eip_allocation_ids = module.eip.eip_allocation_ids
    target_instance_ids = toset(values(module.sftp_instance.instance_ids))
}