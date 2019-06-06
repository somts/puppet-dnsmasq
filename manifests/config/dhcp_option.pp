# Create an dnsmasq dhcp option (--dhcp-option).
define dnsmasq::config::dhcp_option(
  Variant[String,Integer] $option = $name,
  $value,
  Variant[String,Array[String],Undef] $tag = undef,
  Boolean $force = false,
) {
  $key = $force ? {
    true    => 'dhcp-option-force',
    default => 'dhcp-option',
  }
  $_tag = $tag ? {
    undef   => undef,
    default => prefix(flatten([$tag]),'tag:'),
  }

  $content = join(delete_undef_values(flatten([
    $_tag,
    $option,
    $value,
  ])), ',')

  include dnsmasq

  concat::fragment { "dnsmasq-${key}-${name}":
    target  => 'dnsmasq.conf',
    content => "${key}=${content}",
  }
}
