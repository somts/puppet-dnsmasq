# Manage a dnsmasq alias record (--alias).
define dnsmasq::config::alias(
  Variant[Stdlib::IP::Address::Nosubnet,
    Array[Stdlib::IP::Address::Nosubnet,2,2]] $old_ip,
  Stdlib::IP::Address::Nosubnet $new_ip = $name,
  Optional[Stdlib::IP::Address::Nosubnet] $mask = undef,
) {
  $_old_ip = $old_ip ? {
    undef   => undef,
    default => join(flatten([$old_ip]),'-'),
  }

  $content = join(delete_undef_values([
    $_old_ip,
    $new_ip,
    $mask,
  ]), ',')

  include dnsmasq

  concat::fragment { "dnsmasq-alias-${name}":
    target  => 'dnsmasq.conf',
    content => "alias=${content}",
  }
}
