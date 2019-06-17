# Create an dnsmasq dhcp boot (PXE) record for customizing network
# booting (--dhcp-boot).
# [tag:<tag>,]<filename>,[<servername>[,<server address>|<tftp_servername>]]
define dnsmasq::config::dhcp_boot(
  String $file = $name,
  Optional $tag = undef,
  Optional[Stdlib::Host] $servername = undef,
  Optional[Stdlib::Host] $server_address = undef,
) {
  $_tag = $tag ? {
    undef   => undef,
    default => "tag:${tag}",
  }
  $content = join(delete_undef_values(flatten([
    $_tag,
    $file,
    $servername,
    $server_address,
  ])), ',')

  include dnsmasq

  concat::fragment { "dnsmasq-dhcp-boot-${name}":
    target  => 'dnsmasq.conf',
    content => "dhcp-boot=${content}",
  }
}
