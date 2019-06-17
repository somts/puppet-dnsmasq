# Create a dnsmasq txt record (--txt-record).
define dnsmasq::config::txt_record(
  Variant[String[1,255],Array[String[1,255]]] $text,
  String $record = $name,
) {
  $content = join(delete_undef_values(flatten([
    $record,
    suffix(prefix(flatten([$text]),'"'),'"'),
  ])), ',')

  include dnsmasq

  concat::fragment { "dnsmasq-txt-record-${name}":
    target  => 'dnsmasq.conf',
    content => "txt-record=${content}",
  }
}
