# Private class. Manage dnsmasq service
class dnsmasq::service {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  service { 'dnsmasq':
    name      => $dnsmasq::service_name,
    ensure    => $dnsmasq::service_ensure,
    enable    => $dnsmasq::service_enable,
    hasstatus => $dnsmasq::service_hasstatus,
  }
}
