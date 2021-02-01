terraform {
  required_version = ">= 0.12"
  
  backend "azurerm" {
    environment = "public"
  }

  required_providers {
    
    azurerm = {
      version = "~> 2.45"
    }
  }
}

provider "azurerm" {
  features {}
}

variable "name_prefix" {
  type        = string
  description = "A prefix for the naming scheme as part of prefix-base-suffix."
}

variable "name_base" {
  type        = string
  description = "A base for the naming scheme as part of prefix-base-suffix."
}

variable "name_suffix" {
  type        = string
  description = "A suffix for the naming scheme as part of prefix-base-suffix."
}

variable "location" {
  type        = string
  description = "The Azure region where the resources will be created."
}

variable "db_username" {
  type        = string
  description = "The admin username for the database."
}

variable "db_password" {
  type        = string
  description = "The admin password for the database."
}

locals {
  base_name = "${var.name_prefix}-${var.name_base}-${var.name_suffix}"
}

resource "azurerm_resource_group" "rg" {
  name     = local.base_name
  location = var.location
}