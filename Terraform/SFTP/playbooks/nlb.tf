module "new_nlb" {
    source = "../module/nlb"
    eip_allocation_ids = module.nlb_eip.eip_allocation_ids
}