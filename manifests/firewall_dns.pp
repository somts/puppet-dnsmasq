# Manage dnsmasq firewall for DNS
# dnsmasq listens on TCP and UDP, so poke holes for both protocols
class dnsmasq::firewall_dns {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  ['tcp','udp'].each |String $proto| {

    if $dnsmasq::port != 0 and $dnsmasq::firewall_ipv4_manage {
      firewall { "${dnsmasq::firewall_order} dnsmasq IPv4 ${proto} DNS":
        * => $dnsmasq::firewall_defaults + {
          dport => $dnsmasq::port,
          proto => $proto,
        }
      }
    }

    if $dnsmasq::port != 0 and $dnsmasq::firewall_ipv6_manage {
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
