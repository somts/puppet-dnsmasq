# Create a dnsmasq stub zone for caching upstream name resolvers
# (--dhcp-range).
# [tag:<tag>[,tag:<tag>],][set:<tag>,]<start-addr>[,<end-addr>|<mode>][,<netmask>[,<broadcast>]][,<lease time>]
# [tag:<tag>[,tag:<tag>],][set:<tag>,]<start-IPv6addr>[,<end-IPv6addr>|constructor:<interface>][,<mode>][,<prefix-len>][,<lease time>]
define dnsmasq::config::dhcp_range(
  Stdlib::IP::Address::Nosubnet $start_addr,
  Stdlib::IP::Address::Nosubnet $end_addr,
  $netmask,
  $broadcast,
  $constructor,
  $lease_time,
  Optional[Variant[String,Array[String]]] $tag = undef,
  Optional[String] $set_tag = undef,
  Optional[Enum['proxy','ra-only','slaac','ra-names','ra-stateless','ra-advrouter','off-link']] $mode,
) {
  ## VALIDATION

  # Depending on what IPs we got (IPv4 or IPv6), this sets what is valid
  if $ipv4 { # TODO: real check
    if undef != $mode and $mode != 'proxy' {
      fail("Mode ${mode} is not valid for start_addr ${start_addr}")
    }
  } else {
    if undef != $mode and $mode == 'proxy' {
      fail("Mode ${mode} is not valid for start_addr ${start_addr}")
    }
  }

  $_set = $set ? {
    undef   => undef,
    default => "set:${set},",
  }
  $_tag = $tag ? {
    undef   => undef,
    default => "tag:${tag},",
  }
  $_set_tag = $set_tag ? {
    undef   => undef,
    default => "set:${set_tag},",
  }

  include 'dnsmasq'

  # --dhcp-range enables the DHCP server component of dnsmasq, so call
  # the class that conditionally pokes firewall holes for DHCP.
  include 'dnsmasq::firewall::dhcp'

  concat::fragment { "dnsmasq-dhcp-range-${name}":
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dhcp.erb'),
  }
}
