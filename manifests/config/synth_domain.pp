# Create a dnsmasq synthetic domain (--synth-domain).
define dnsmasq::config::synth_domain(
  Stdlib::Fqdn $domain = $name,
  Variant[Stdlib::IP::Address,Array[Stdlib::IP::Address]] $address_range,
  String $prefix,
) {
  include dnsmasq

  $content = join(delete_undef_values(flatten([
    $domain,
    $address_range,
    $prefix,
  ])), ',')

  concat::fragment { "dnsmasq-synth-domain-${name}":
    target  => 'dnsmasq.conf',
    content => "synth-domain=${content}",
  }
}
