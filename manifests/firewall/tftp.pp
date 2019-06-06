# Manage dnsmasq firewall for tftp
class dnsmasq::firewall::tftp {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $dnsmasq::firewall_ipv4_manage {
    firewall { "${dnsmasq::firewall_order} dnsmasq IPv4 UDP TFTP":
      * => $dnsmasq::firewall_defaults + {
        dport => 69,
        proto => 'udp',
      }
    }
  }
  if $dnsmasq::firewall_ipv6_manage {
    firewall { "${dnsmasq::firewall_order} dnsmasq IPv6 UDP TFTP":
      * => $dnsmasq::firewall_defaults + {
        dport    => 69,
        proto    => 'udp',
        provider => 'ip6tables',
      }
    }
  }
}
