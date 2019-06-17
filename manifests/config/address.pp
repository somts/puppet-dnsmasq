# Manage a dnsmasq A record (--address).
define dnsmasq::config::address(
  Variant[Enum['#'],Stdlib::Fqdn,Array[Stdlib::Fqdn,1]] $domain = $name,
  Variant[Enum['#'],Stdlib::IP::Address::Nosubnet,Undef] $ipaddr = undef,
) {
  if $domain == '#' and $ipaddr == undef {
    fail('domain cannot be "#" when ipaddr is unset')
  } elsif $domain == '#' and $ipaddr == '#' {
    fail('domain cannot be "#" when ipaddr is "#"')
  }

  $_domain = prefix(flatten([$domain]),'/')

  $content = join(delete_undef_values(flatten([
    $_domain,
    '/',
    $ipaddr,
  ])),'')

  include dnsmasq

  concat::fragment { "dnsmasq-address-${name}":
    target  => 'dnsmasq.conf',
    content => "address=${content}",
  }
}
