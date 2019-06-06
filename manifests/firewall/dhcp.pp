# Manage dnsmasq firewall for dhcp
class dnsmasq::firewall::dhcp {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $dnsmasq::firewall_ipv4_manage {
    firewall { "${dnsmasq::firewall_order} dnsmasq IPv4 UDP DHCP":
      * => $dnsmasq::firewall_defaults + {
        dport => '67-68',
        proto => 'udp',
      }
    }
  }
  if $dnsmasq::firewall_ipv6_manage {
    firewall { "${dnsmasq::firewall_order} dnsmasq IPv6 UDP DHCP":
      * => $dnsmasq::firewall_defaults + {
        dport => '67-68',
        proto => 'udp',
      }
    }
  }
}
