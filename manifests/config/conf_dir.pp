# Create a dnsmasq conf-dir record (--conf-dir).
define dnsmasq::config::conf_dir(
  Stdlib::Absolutepath $conf_dir = $name,
) {
  include dnsmasq

  concat::fragment { "dnsmasq-conf-dir-${name}":
    target  => 'dnsmasq.conf',
    content => "conf-dir=${conf_dir}",
  }
}
