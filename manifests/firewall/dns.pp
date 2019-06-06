# Manage dnsmasq firewall for DNS
class dnsmasq::firewall::dns {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  # dnsmasq listens on TCP and UDP, so poke holes for both protos
  ['tcp','udp'].each |String $proto| {

    # Poke DNS IPv4 firewall holes, if requested
    if $dnsmasq::firewall_ipv4_manage {
      firewall { "${dnsmasq::firewall_order} dnsmasq IPv4 ${proto} DNS":
        * => $dnsmasq::firewall_defaults + {
          dport => $dnsmasq::port,
          proto => $proto,
        }
      }
    }

    # Poke DNS IPv6 firewall holes, if requested
    if $dnsmasq::firewall_ipv6_manage {
      firewall { "${dnsmasq::firewall_order} dnsmasq IPv6 ${proto} DNS":
        * => $dnsmasq::firewall_defaults + {
          dport    => $dnsmasq::port,
          proto    => $proto,
          provider =>  'ip6tables',
        }
      }
    }
  }
}
