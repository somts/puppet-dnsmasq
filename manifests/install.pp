# Private class. Install dnsmasq
class dnsmasq::install {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  if $dnsmasq::package_manage {
    package { $dnsmasq::package_name:
      ensure   => $dnsmasq::package_ensure,
      provider => $dnsmasq::package_provider,
    }
  }
}
