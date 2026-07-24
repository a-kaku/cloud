module "nlb" {
  source = "../module/nlb"

  eip_allocation_ids = var.eip_allocation_ids
  target_instance_ids = var.target_instance_ids
  nlb_config = var.nlb_config
}
