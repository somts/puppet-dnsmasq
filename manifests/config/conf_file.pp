# Create a dnsmasq conf-file record (--conf-file).
define dnsmasq::config::conf_file(
  Stdlib::Absolutepath $conf_file = $name,
) {
  include dnsmasq

  concat::fragment { "dnsmasq-conf-file-${name}":
    target  => 'dnsmasq.conf',
    content => "conf-file=${conf_file}",
  }
}
