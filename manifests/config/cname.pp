# Manage a dnsmasq CNAME record (--cname).
define dnsmasq::config::cname(
  Stdlib::Fqdn $target,
  Variant[Stdlib::Fqdn,Array[Stdlib::Fqdn]] $cname = $name,
  Optional[Integer] $ttl = undef,
) {

  include dnsmasq

  $content = join(delete_undef_values(flatten([
    $cname,
    $target,
    $ttl,
  ])), ',')

  concat::fragment { "dnsmasq-cname-${name}":
    target  => 'dnsmasq.conf',
    content => "cname=${content}",
  }
}
