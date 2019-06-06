# Create a dnsmasq domain (--domain).
define dnsmasq::config::domain(
  Stdlib::Fqdn $domain = $name,
  Boolean $local = false,
  Optional[Stdlib::IP::Address] $subnet = undef,
) {
  include dnsmasq

  $_local = $local ? {
    true  => 'local',
    false => undef,
  }

  $content = join(delete_undef_values([
    $domain,
    $subnet,
    $_local,
  ]), ',')

  concat::fragment { "dnsmasq-domain-${name}":
    target  => 'dnsmasq.conf',
    content => "domain=${content}",
  }
}
