# Create a dnsmasq dnsrr record (--dns-rr).
# See https://en.wikipedia.org/wiki/List_of_DNS_record_types
define dnsmasq::config::dns_rr (
  Variant[String,Integer] $rr_number = $name,
  Optional[String] $hex_data = undef,
) {
  # Remove spaces or colons from hex data for consistency.
  $_hex_data = $hex_data ? {
    undef   => undef,
    default => downcase(regsubst($hex_data,'[ :]','','G')),
  }
  if $_hex_data { validate_re($_hex_data,'^[a-f0-9]+$') }

  $content = join(delete_undef_values([
    $name,
    $rr_number,
    $_hex_data,
  ]), ',')

  include dnsmasq

  concat::fragment { "dnsmasq-dns-rr-${name}":
    target  => 'dnsmasq.conf',
    content => "dns-rr=${content}",
  }
}
