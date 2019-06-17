# Create a dnsmasq srv-host record (--srv-host).
# <_service>.<_prot>.[<domain>],[<target>[,<port>[,<priority>[,<weight>]]]]
define dnsmasq::config::srv_host(
  String $service = $name,
  Optional[String] $domain = undef,
  Optional[String] $target = undef,
  Optional[Stdlib::Port] $port = undef,
  Optional[Integer] $priority = undef,
  Optional[Integer] $weight = undef,
) {
  include dnsmasq

  $_service = $domain ? {
    undef   => $service,
    default => "${service}.${domain}",
  }

  $content = join(delete_undef_values([
    $_service,
    $target,
    $port,
    $priority,
    $weight,
  ]), ',')

  concat::fragment { "dnsmasq-srv-host-${name}":
    target  => 'dnsmasq.conf',
    content => "srv-host=${content}",
  }
}
