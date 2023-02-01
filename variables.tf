var "hub_virtual_networks" {
  description = "A map of hub virtual networks to create"
  type = map(object({
    name                = string
    address_space       = list(string)
    location            = string
    resource_group_name = string

    bgp_community           = optional(string, "")
    ddos_protection_plan    = optional(string, "")
    dns_servers             = optional(list(string), [])
    flow_timeout_in_minutes = optional(number, 4)
    mesh_peering_enabled    = optional(bool, true)       # peer to other hub networks with this flag enabled?
    routing_address_space   = optional(list(string), []) # used to create route table entries for other hub networks
    tags                    = optional(map(string), {})

    route_table_entries = optional(map(object({ # additional entries for this hub's route table
      name           = string
      address_prefix = string
      next_hop_type  = string # Possible values: Internet, VirtualAppliance, VirtualNetworkGateway, VnetLocal, None

      has_bgp_override    = optional(bool, false)
      next_hop_ip_address = optional(string, "") # only required if next_hop_type is VirtualAppliance
    })), {})

    subnets = optional(map(object(
      {
        address_prefixes = list(string) # (Required) The address prefixes to use for the subnet.
        nat_gateway = optional(object({
          id = string # (Required) The ID of the NAT Gateway which should be associated with the Subnet. Changing this forces a new resource to be created.
        }))
        network_security_group = optional(object({
          id = string # (Required) The ID of the Network Security Group which should be associated with the Subnet. Changing this forces a new association to be created.
        }))
        private_endpoint_network_policies_enabled     = optional(bool, true)  # (Optional) Enable or Disable network policies for the private endpoint on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. Defaults to true.
        private_link_service_network_policies_enabled = optional(bool, true)  # (Optional) Enable or Disable network policies for the private link service on the subnet. Setting this to true will Enable the policy and setting this to false will Disable the policy. Defaults to true.
        assign_generated_route_table                  = optional(bool, true)  # (Optional) Should the Route Table generated by this module be associated with this Subnet? Defaults to true. Cannot be used with external_route_table
        external_route_table                          = optional(string, "")  # The ID of the Route Table which should be associated with the Subnet. Changing this forces a new association to be created. Cannot be used with assign_generated_route_table
        service_endpoints                             = optional(set(string)) # (Optional) The list of Service endpoints to associate with the subnet. Possible values include: Microsoft.AzureActiveDirectory, Microsoft.AzureCosmosDB, Microsoft.ContainerRegistry, Microsoft.EventHub, Microsoft.KeyVault, Microsoft.ServiceBus, Microsoft.Sql, Microsoft.Storage and Microsoft.Web.
        service_endpoint_policy_ids                   = optional(set(string)) # (Optional) The list of IDs of Service Endpoint Policies to associate with the subnet.
        delegations = optional(list(
          object(
            {
              name = string # (Required) A name for this delegation.
              service_delegation = object({
                name    = string                 # (Required) The name of service to delegate to. Possible values include Microsoft.ApiManagement/service, Microsoft.AzureCosmosDB/clusters, Microsoft.BareMetal/AzureVMware, Microsoft.BareMetal/CrayServers, Microsoft.Batch/batchAccounts, Microsoft.ContainerInstance/containerGroups, Microsoft.ContainerService/managedClusters, Microsoft.Databricks/workspaces, Microsoft.DBforMySQL/flexibleServers, Microsoft.DBforMySQL/serversv2, Microsoft.DBforPostgreSQL/flexibleServers, Microsoft.DBforPostgreSQL/serversv2, Microsoft.DBforPostgreSQL/singleServers, Microsoft.HardwareSecurityModules/dedicatedHSMs, Microsoft.Kusto/clusters, Microsoft.Logic/integrationServiceEnvironments, Microsoft.MachineLearningServices/workspaces, Microsoft.Netapp/volumes, Microsoft.Network/managedResolvers, Microsoft.Orbital/orbitalGateways, Microsoft.PowerPlatform/vnetaccesslinks, Microsoft.ServiceFabricMesh/networks, Microsoft.Sql/managedInstances, Microsoft.Sql/servers, Microsoft.StoragePool/diskPools, Microsoft.StreamAnalytics/streamingJobs, Microsoft.Synapse/workspaces, Microsoft.Web/hostingEnvironments, Microsoft.Web/serverFarms, NGINX.NGINXPLUS/nginxDeployments and PaloAltoNetworks.Cloudngfw/firewalls.
                actions = optional(list(string)) # (Optional) A list of Actions which should be delegated. This list is specific to the service to delegate to. Possible values include Microsoft.Network/networkinterfaces/*, Microsoft.Network/virtualNetworks/subnets/action, Microsoft.Network/virtualNetworks/subnets/join/action, Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action and Microsoft.Network/virtualNetworks/subnets/unprepareNetworkPolicies/action.
              })
            }
          )
        ))
      }
    )), {})

    # TODO: Firewall variables

    # TODO: ERGW variables

    # TODO: VPNGW variables
  }))
  default = {}
}
