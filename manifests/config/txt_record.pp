# Create a dnsmasq txt record (--txt-record).
define dnsmasq::config::txt_record(
  String $record = $name,
  Variant[String,Array[String]] $text,
) {
  $content = join(delete_undef_values(flatten([
    $record,
    $text,
  ])), ',')

  include dnsmasq

  concat::fragment { "dnsmasq-txt-record-${name}":
    target  => 'dnsmasq.conf',
    content => "txt-record=${content}"),
  }
}
