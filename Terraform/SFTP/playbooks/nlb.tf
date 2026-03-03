module "nlb" {
  source = "../module/nlb"

  eip_allocation_ids = var.eip_allocation_ids
  target_instance_ids = var.target_instance_ids
}

module "listener" {
  source = "../module/listener"

  target_instance_ids = var.target_instance_ids
}

module "tg" {
  source = "../module/target_group"

  target_instance_ids = var.target_instance_ids
}

module "attachment" {
  source = "../module/attachment"

  target_instance_ids = var.target_instance_ids
}