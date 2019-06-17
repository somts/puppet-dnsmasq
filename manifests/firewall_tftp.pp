# Manage dnsmasq firewall for tftp
class dnsmasq::firewall_tftp {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $dnsmasq::enable_tftp and $dnsmasq::firewall_ipv4_manage {
    firewall { "${dnsmasq::firewall_order} dnsmasq IPv4 UDP TFTP":
      * => $dnsmasq::firewall_defaults + { dport => 69 }
    }
    if $dnsmasq::tftp_port_range_start and $dnsmasq::tftp_port_range_end {
      firewall { "${dnsmasq::firewall_order} dnsmasq IPv4 UDP TFTP Port Range":
        * => $dnsmasq::firewall_defaults + {
          dport =>
          "${dnsmasq::tftp_port_range_start}-${dnsmasq::tftp_port_range_end}",
        }
      }
    }
  }

  if $dnsmasq::enable_tftp and $dnsmasq::firewall_ipv6_manage {
    firewall { "${dnsmasq::firewall_order} dnsmasq IPv6 UDP TFTP":
      * => $dnsmasq::firewall_defaults + {
        dport    => 69,
        provider => 'ip6tables',
      }
    }
    if $dnsmasq::tftp_port_range_start and $dnsmasq::tftp_port_range_end {
      firewall { "${dnsmasq::firewall_order} dnsmasq IPv6 UDP TFTP Port Range":
        * => $dnsmasq::firewall_defaults + {
          provider => 'ip6tables',
          dport    =>
          "${dnsmasq::tftp_port_range_start}-${dnsmasq::tftp_port_range_end}",
        }
      }
    }
  }
}
