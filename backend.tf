terraform {
  backend "azurerm" {
      resource_group_name   = "DCA-RG"
      storage_account_name  = "terraformstateeaccount"
      container_name        = "terraformstatecontainer"
      key                   = "terraform.tfstate"
  }
}
