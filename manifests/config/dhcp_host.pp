# Create a dnsmasq stub zone for caching upstream name resolvers
# (--dhcp-host).
define dnsmasq::config::dhcp_host(
  Optional[Stdlib::IP::Address::Nosubnet] $ipaddr,
  Optional[Stdlib::Fqdn] $hostname = $name,
  Boolean $ignore = false,
  Variant[Stdlib::MAC,Stdlib::Host,Undef] $hwaddr,
  Optional[String] $id = undef,
  Optional[String] $set = undef,
  Variant[Integer,Enum['infinite'],Undef] $lease_time = undef,
) {
  if undef == $ipaddr and undef == $hostname and undef == $hwaddr {
    fail('Not enough parameters specified')
  }

  $_hwaddr = $hwaddr ? {
    undef   => undef,
    default => downcase($hwaddr),
  }
  $_id = $id ? {
    undef   => undef,
    default => "id:${id}",
  }
  $_set = $set ? {
    undef   => undef,
    default => "set:${set}",
  }
  $_ignore = $ignore ? {
    false   => undef,
    default => 'ignore',
  }
  if $ipaddr =~ Stdlib::IP::Address::V6 {
    $_ipaddr = join(['[',downcase($ipaddr),']'],'')
  } else {
    $_ipaddr = $ipaddr
  }

  $content = join(delete_undef_values([
    $_hwaddr,
    $_id,
    $_set,
    $_ipaddr,
    $hostname,
    $lease_time,
    $_ignore,
  ]), ',')

  include dnsmasq

  concat::fragment { "dnsmasq-dhcp-host-${name}":
    target  => 'dnsmasq.conf',
    content => "dhcp-host=${content}",
  }
}
