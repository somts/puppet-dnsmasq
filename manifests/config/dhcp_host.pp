# Create a dnsmasq stub zone for caching upstream name resolvers
# (--dhcp-host).
define dnsmasq::config::dhcp_host(
  Stdlib::IP::Address::Nosubnet $ipaddr,
  Stdlib::Fqdn $hostname = $name,
  Boolean $ignore = false,
  Optional[Stdlib::MAC] $hwaddr,
  Optional[String] $id = undef,
  Optional[String] $tag = undef,
  Optional[Integer] $lease_time = undef,
) {
  $_hwaddr = $hwaddr ? {
    undef   => undef,
    default => downcase($hwaddr),
  }
  $_id = $id ? {
    undef   => undef,
    '*'     => '*',
    default => "id:${id}",
  }
  $_tag = $tag ? {
    undef   => undef,
    default => "set:${tag}",
  }
  $_ignore = $ignore ? {
    false   => undef,
    default => 'ignore',
  }

  $content = join(delete_undef_values([
    $_hwaddr,
    $_id,
    $_tag,
    $ipaddr,
    $lease_time,
    $_ignore,
  ]), ',')

  include dnsmasq

  concat::fragment { "dnsmasq-dhcp-host-${name}":
    target  => 'dnsmasq.conf',
    content => "dhcp-host=${content}",
  }
}
