# Manage a dnsmasq A record (--address).
define dnsmasq::config::address(
  Stdlib::IP::Address::Nosubnet $ipaddr,
  Variant[Stdlib::Fqdn,Array[Stdlib::Fqdn]] $address = $name,
) {
  $_address = join(flatten([$address]),'/')

  include dnsmasq

  concat::fragment { "dnsmasq-address-${name}":
    target  => 'dnsmasq.conf',
    content => "address=/${_address}/${ipaddr}",
  }
}
