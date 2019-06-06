# Manage a dnsmasq add-subnet record (--add-subnet).
define dnsmasq::config::add_subnet(
  Stdlib::IP::Address $ip,
  Stdlib::Fqdn $address = $name,
) {
  include dnsmasq

  concat::fragment { "dnsmasq-add-subnet-${name}":
    target  => 'dnsmasq.conf',
    content => "add-subnet=/${address}/${ip}"),
  }
}
