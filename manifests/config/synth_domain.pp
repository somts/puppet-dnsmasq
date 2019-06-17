# Create a dnsmasq synthetic domain (--synth-domain).
define dnsmasq::config::synth_domain(
  String $prefix,
  Array[Stdlib::IP::Address::Nosubnet,2,2] $address_range,
  Stdlib::Fqdn $domain = $name,
) {
  include dnsmasq

  $content = join(delete_undef_values([
    $domain,
    $address_range[0],
    $address_range[1],
    $prefix,
  ]), ',')

  concat::fragment { "dnsmasq-synth-domain-${name}":
    target  => 'dnsmasq.conf',
    content => "synth-domain=${content}",
  }
}
