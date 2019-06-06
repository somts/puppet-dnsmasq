# Create a dnsmasq A,AAAA and PTR record (--host-record).
define dnsmasq::config::host_record(
  Variant[Stdlib::IP::Address::Nosubnet,Array[Stdlib::IP::Address::Nosubnet,1,2]] $ipaddr,
  Variant[Stdlib::Fqdn,Array[Stdlib::Fqdn]] $host_record = $name,
  Optional[Integer] $ttl = undef,
) {
  $content = join(delete_undef_values(flatten([
    $host_record,
    $ipaddr,
    $ttl,
  ])), ',')

  include dnsmasq

  concat::fragment { "dnsmasq-host-record-${name}":
    target  => 'dnsmasq.conf',
    content => "host-record=${content}",
  }
}
