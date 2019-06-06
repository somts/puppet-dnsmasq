# Configure the DNS server to query external DNS servers (--server).
define dnsmasq::config::server(
  Stdlib::Host $ipaddr = $name,
  Optional[Variant[Stdlib::Fqdn,Array[Stdlib::Fqdn]]] $domain = undef,
  Optional[Stdlib::Port] $port = undef,
) {
  $_domain = $domain ? {
    undef   => undef,
    default => join(prefix(flatten([$domain]),'/'),''),
  }
  $_ipaddr = $port ? {
    undef   => $ipaddr,
    default => "${ipaddr}#${port}",
  }
  $content = join(delete_undef_values([
    $_domain,
    $_ipaddr,
  ]), '/')

  include dnsmasq

  concat::fragment { "dnsmasq-server-${name}":
    target  => 'dnsmasq.conf',
    content => "server=${content}",
  }
}
