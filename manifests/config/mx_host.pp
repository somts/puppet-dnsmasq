# Create an dnsmasq mx-host record (--mx-host).
define dnsmasq::config::mx_host(
  Stdlib::Fqdn $mx_host = $name,
  Optional[Stdlib::Fqdn] $hostname = undef,
  Optional[Integer] $preference = undef,
) {
  $content = join(delete_undef_values(flatten([
    $mx_host,
    $hostname,
    $preference,
  ])), ',')

  include dnsmasq

  concat::fragment { "dnsmasq-mx-host-${name}":
    order   => '08',
    target  => 'dnsmasq.conf',
    content => "mx-host=${content}",
  }
}
