# Manage dnsmasq firewall for dhcp
class dnsmasq::firewall_dhcp {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  # IPv4 DHCP needs UDP/67 unblocked.
  if $dnsmasq::firewall_ipv4_manage {
    firewall { "${dnsmasq::firewall_order} dnsmasq IPv4 UDP DHCP":
      * => $dnsmasq::firewall_defaults + { dport => '67' }
    }
  }

  # IPv6 DHCP needs UDP/547 unblocked, as well as all some ICMPv6 in
  # case RA and/or SLAAC is used.
  #
  # NOTE: Such logic could possibly be more cleanly applied the defined
  # type dnsmasq::config::dhcp_range, since that type is aware of what
  # mode each --dhcp-range clause is requesting. However, a first read
  # of DHCPv6, RA and SLAAC shows a hefty amount of coordinating
  # traffic via ICMPv6 for all these modes of operation. Thus, it seems
  # best, for now, to simply wholesale unblock ICMPv6, when DHCPv6 and
  # IPv6 firewalls are requested.
  if $dnsmasq::firewall_ipv6_manage {
    firewall {
      "${dnsmasq::firewall_order} dnsmasq IPv6 UDP DHCPv6":
        * => $dnsmasq::firewall_defaults + { dport => '547' },;
      "${dnsmasq::firewall_order} dnsmasq IPv6 ICMPv6":
        * => $dnsmasq::firewall_defaults + { proto => 'ipv6-icmp' },;
    }
  }
}
