# Create an dnsmasq mx-host record (--mx-host).
define dnsmasq::config::mx_host(
  Stdlib::Fqdn $mx_name = $name,
  Optional[Stdlib::Fqdn] $hostname = undef,
  Optional[Integer[default,255]] $preference = undef,
) {
  $content = join(delete_undef_values([
    $mx_name,
    $hostname,
    $preference,
  ]), ',')

  include dnsmasq

  concat::fragment { "dnsmasq-mx-host-${name}":
    target  => 'dnsmasq.conf',
    content => "mx-host=${content}",
  }
}
