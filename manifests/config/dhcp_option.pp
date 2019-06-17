# Create an dnsmasq dhcp option (--dhcp-option).
# [tag:<tag>,[tag:<tag>,]][encap:<opt>,][vi-encap:<enterprise>,][vendor:[<vendor-class>],][<opt>|option:<opt-name>|option6:<opt>|option6:<opt-name>],[<value>[,<value>]]
define dnsmasq::config::dhcp_option(
  Variant[String,Integer,Array[String,Integer]] $value,
  Variant[Pattern['^option:','^option6:'],Integer] $option = $name,
  Variant[String,Integer,Undef] $encap = undef,
  Variant[String,Integer,Undef] $vi_encap = undef,
  Variant[String,Undef] $vendor = undef,
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
  $_encap = $encap ? {
    undef   => undef,
    default => "encap:${encap}",
  }
  $_vi_encap = $vi_encap ? {
    undef   => undef,
    default => "vi-encap:${vi_encap}",
  }
  $_vendor = $vendor ? {
    undef   => undef,
    default => "vendor:${vendor}",
  }

  $content = join(delete_undef_values(flatten([
    $_tag,
    $_encap,
    $_vi_encap,
    $_vendor,
    $option,
    $value,
  ])), ',')

  include dnsmasq

  concat::fragment { "dnsmasq-${key}-${name}":
    target  => 'dnsmasq.conf',
    content => "${key}=${content}",
  }
}
