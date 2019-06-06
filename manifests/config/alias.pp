# Manage a dnsmasq alias record (--alias).
define dnsmasq::config::alias(
  Stdlib::IP::Address::Nosubnet $new_ip = $name,
  Optional[String] $mask = undef,
  Optional[Stdlib::IP::Address::Nosubnet] $old_ip = undef,
  Optional[Stdlib::IP::Address::Nosubnet] $start_ip = undef,
  Optional[Stdlib::IP::Address::Nosubnet] $end_ip = undef,
) {
  if undef == $old_ip and (undef == $start_ip or undef == $end_ip) {
    fail('Must specify old_ip or start_ip and end_ip')
  }

  $_old_ip = $old_ip ? {
    undef   => "${start_ip}-${end_ip}",
    default => $old_ip,
  }
  $content = join(delete_undef_values([
    $_old_ip,
    $new_ip,
    $mask,
  ]), ',')

  include dnsmasq

  concat::fragment { "dnsmasq-alias-${name}":
    target  => 'dnsmasq.conf',
    content => "alias=${content}"),
  }
}
