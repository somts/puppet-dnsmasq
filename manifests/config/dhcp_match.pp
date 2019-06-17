# Create a dnsmasq dhcp match (--dhcp-match)
define dnsmasq::config::dhcp_match(
  String $set,
  Variant[String,Integer] $option = $name,
  Variant[String,Integer,Undef] $value = undef,
) {
  $_set = "set:${set}"
  $_option = $option ? {
    undef        => undef,
    /^[0-9]+$/   => $option,
    /^vi-encap:/ => $option,
    /^option:/   => $option,
    default      => "option:${option}",
  }
  $content = join(delete_undef_values([
    $_set,
    $_option,
    $value,
  ]), ',')

  include dnsmasq

  concat::fragment { "dnsmasq-dhcp-match-${name}":
    target  => 'dnsmasq.conf',
    content => "dhcp-match=${content}",
  }
}
