# Create a dnsmasq ptr record (--ptr-record).
define dnsmasq::config::ptr_record(
  String $record = $name,
  Optional[String] $target,
) {
  $content = join(delete_undef_values(flatten([
    $record,
    $target,
  ])), ',')

  include dnsmasq

  concat::fragment { "dnsmasq-ptr-record-${name}":
    target  => 'dnsmasq.conf',
    content => "ptr-record=${content}"),
  }
}
