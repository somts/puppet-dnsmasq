# Create a dnsmasq stub zone for caching upstream name resolvers
# (--dhcp-range).
# [tag:<tag>[,tag:<tag>],][set:<tag>,]<start-addr>[,<end-addr>|<mode>][,<netmask>[,<broadcast>]][,<lease time>]
# [tag:<tag>[,tag:<tag>],][set:<tag>,]<start-IPv6addr>[,<end-IPv6addr>|constructor:<interface>][,<mode>][,<prefix-len>][,<lease time>]
#
# NOTE: --dhcp-range enables the DHCP service within dnsmasq, so
# this type will include the class that conditionally opens up the
# firewall for DHCP/DHCPv6.
define dnsmasq::config::dhcp_range(
  Variant[Enum['::'],Stdlib::IP::Address::Nosubnet] $start_addr = $name,
  Variant[Integer,Pattern['^\d+(h|m)$'],Enum['infinite']] $lease_time = '1h',
  Optional[Stdlib::IP::Address::Nosubnet] $end_addr = undef,
  Optional[Integer[default,128]] $prefix_len = undef,
  Variant[Stdlib::IP::Address::V4,Integer[default,32],Undef] $netmask = undef,
  Optional[Stdlib::IP::Address::V4] $broadcast = undef,
  Optional[String] $constructor = undef,
  Optional[Variant[String,Array[String]]] $tag = undef,
  Optional[String] $set = undef,
  Optional[Enum['static','proxy','ra-only','slaac','ra-names',
  'ra-stateless', 'ra-advrouter','off-link']] $mode = undef,
) {
  ## VALIDATION

  if $start_addr =~ Stdlib::IP::Address::V4 {

    if undef != $mode and $mode != 'static' and $mode != 'proxy' {
      fail("Invalid IPv4 mode, ${mode}")
    }
    if undef != $prefix_len  { fail('Invalid IPv4 parameter, prefix_len' ) }
    if undef != $constructor { fail('Invalid IPv4 parameter, constructor') }

  # Catch '::', so no elsif $start_addr =~ Stdlib::IP::Address::V6
  } else {

    if undef != $mode and $mode == 'proxy' {
      fail("Invalid IPv6 mode, ${mode}")
    }
    if undef != $netmask   { fail('Invalid IPv6 parameter, netmask'  ) }
    if undef != $broadcast { fail('Invalid IPv6 parameter, broadcast') }
  }

  ## CLASS VARAIBLES

  $_tag = $tag ? {
    undef   => undef,
    default => join(prefix(flatten([$tag]),'tag:'),','),
  }
  $_set = $set ? {
    undef   => undef,
    default => "set:${set}",
  }
  $_constructor = $constructor ? {
    undef   => undef,
    default => "constructor:${constructor}",
  }

  if $start_addr =~ Stdlib::IP::Address::V4 {
    $content = join(delete_undef_values([
      $_tag,
      $_set,
      $start_addr,
      $end_addr,
      $mode,
      $netmask,
      $broadcast,
      $lease_time,
    ]),',')

  # Catch '::', so no elsif $start_addr =~ Stdlib::IP::Address::V6
  } else {
    $content = join(delete_undef_values([
      $_tag,
      $_set,
      $start_addr,
      $end_addr,
      $_constructor,
      $mode,
      $prefix_len,
      $lease_time,
    ]),',')
  }

  ##  MANAGED RESOURCES

  include 'dnsmasq'
  include 'dnsmasq::firewall_dhcp'

  concat::fragment { "dnsmasq-dhcp-range-${name}":
    target  => 'dnsmasq.conf',
    content => "dhcp-range=${content}",
  }
}
