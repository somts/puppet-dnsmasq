# Create an dnsmasq dhcp boot (PXE) record for customizing network
# booting (--dhcp-boot).
define dnsmasq::config::dhcp_boot(
  String $file,
  String $dhcp_boot = $name,
  Optional $tag = undef,
  Optional $hostname = undef,
  Optional $bootserver = undef,
) {
  $_tag = $tag ? {
    undef   => undef,
    default => "tag:${tag}",
  }
  $content = join(delete_undef_values(flatten([
    $_tag,
    $file,
    $hostname,
    $bootserver,
  ])), ',')

  include dnsmasq

  concat::fragment { "dnsmasq-dhcp-boot-${name}":
    target  => 'dnsmasq.conf',
    content => "dhcp-boot=${content}"),
  }
}
