# Create a dnsmasq srv-host record (--srv-host).
# <_service>.<_prot>.[<domain>],[<target>[,<port>[,<priority>[,<weight>]]]]
define dnsmasq::config::srv_host(
  String $srv = $name,
  Optional[String] $domain = undef,
  Optional[String] $target = undef,
  Optional[Integer] $priority = undef,
  Optional[Integer] $weight = undef,
) {
  include dnsmasq

  $_srv = $domain ? {
    undef   => $srv,
    default => "${srv}.${domain}",
  }

  $content = join(delete_undef_values(flatten([
    $_srv,
    $target,
    $port,
    $priority,
    $weight,
  ])), ',')

  concat::fragment { "dnsmasq-srv-host-${name}":
    target  => 'dnsmasq.conf',
    content => "srv-host=${content}"),
  }
}
