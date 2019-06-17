# Private class. Manage dnsmasq service
class dnsmasq::service {
  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  # Calculate path to include based on .conf file. For
  # /etc/dnsmasq.conf, this will be '/'.
  $dname = dirname(dirname($dnsmasq::dnsmasq_conf_file))
  $bin   = $dname ? { '/' => '/bin' , default => "${dname}/bin"  }
  $sbin  = $dname ? { '/' => '/sbin', default => "${dname}/sbin" }

  # Run a local syntax check on dnsmasq before restarting the service.
  exec { 'dnsmasq --test':
    command     => "dnsmasq --conf-file=${dnsmasq::dnsmasq_conf_file} --test",
    path        => unique([$bin,$sbin,'/bin','/sbin','/usr/bin','/usr/sbin']),
    refreshonly => true,
  }
  -> service { 'dnsmasq':
    ensure    => $dnsmasq::service_ensure,
    enable    => $dnsmasq::service_enable,
    hasstatus => $dnsmasq::service_hasstatus,
    name      => $dnsmasq::service_name,
  }
}
