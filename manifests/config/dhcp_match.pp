# Create a dnsmasq dhcp match (--dhcp-match)
define dnsmasq::config::dhcp_match(
  Variant[String,Integer] $option = $name,
  String $tag,
  Optional[String] $value,
) {
  $_tag = $tag ? {
    undef   => undef,
    default => "set:${tag}",
  }
  $_option = $option ? {
    undef        => undef,
    /^[0-9]+$/   => $option,
    /^vi-encap:/ => $option,
    /^option:/   => $option,
    default      => "option:${option}",
  }
  $content = join(delete_undef_values([
    $_tag,
    $_option,
    $value,
  ]), '')

  include dnsmasq

  concat::fragment { "dnsmasq-dhcp-match-${name}":
    target  => 'dnsmasq.conf',
    content => "dhcp-match=${content}",
  }
}
