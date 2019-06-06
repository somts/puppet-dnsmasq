# Manage dnsmasq firewall
class dnsmasq::firewall {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }
  if $::kernel != 'Linux'
  and ($dnsmasq::firewall_ipv4_manage or $dnsmasq::firewall_ipv6_manage) {
    fail("${::kernel} is unsupported by ${name}")
  }

  if $dnsmasq::port != 0   { include 'dnsmasq::firewall::dns'  }
  if $dnsmasq::enable_tftp { include 'dnsmasq::firewall::tftp' }
}
