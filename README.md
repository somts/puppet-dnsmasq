### DESCRIPTION

Manage the dnsmasq service.

Much of this module is a direct mapping of the parameter descriptions at
[http://www.thekelleys.org.uk/dnsmasq/docs/dnsmasq-man.html] and mapping
that to Puppet-compatible parameters (and back). It is forked from
[https://github.com/dsbaars/puppet-dnsmasq], which was forked from
[https://github.com/rlex/puppet-dnsmasq], but has been heavily modified
to address some issues:

* The original module has not been updated since Puppet 3 and is not forward-compatible. The fork made the module Puppet 4 compatible, but minimally. At the time of this writing, both versions of Puppet are no longer supported, so it is time to move on
* Changed parameter names and defined types to strictly match the assocaited parameters named from the man page, and sorted under *dnsmasq::config* for organization (E.G. `--dhcp-host` in the *.conf* becomes Puppet Defined Type *dnsmasq::config::dhcp_host*)
* This module makes heavy use of Data Types, which was not available in Puppet 3, including some network-specific Data Types from [https://forge.puppet.com/puppetlabs/stdlib]
* Add moderate logic to open up firewall holes for the various sub-services dnsmasq can support (DHCP, DNS, TFTP).

It features some advanced features like:

* Basic dnsmasq management (service, installation)
* Cross-OS support (Debian, Ubuntu, RHEL, FreeBSD)
* Loads of options in basic config (ie TFTP)
(If you need any additional option that does not supported in this module, just ping me)
* Support for DHCP configuration.
* Support for adding static DHCP records (MAC -> IP binding)
* Support for adding static DNS records (IP -> hostname binding)
* Support for DHCP options
* Support for dnsmasq tagging system
* And much more

### DEPENDENCIES

* puppet >= 5.0
* puppetlabs/concat >= 1.0.0
* puppetlabs/firewall >= 1.0.0
* puppetlabs/stdlib >= 3.2.0

### BUILD STATUS
[![Build Status](https://travis-ci.org/somts/puppet-dnsmasq.svg?branch=master)](https://travis-ci.org/somts/puppet-dnsmasq)

### Basic class

Will install dnsmasq to act as DNS and TFTP (if specified) server

Example basic class config. Please refer to table below to see all possible variables

```puppet
class { 'dnsmasq':
  interface         => 'lo',
  listen_address    => '192.168.39.1',
  no_dhcp_interface => '192.168.49.1',
  domain            => 'int.lan',
  port              => '53',
  expand_hosts      => true,
  enable_tftp       => true,
  tftp_root         => '/var/lib/tftpboot',
  dhcp_boot         => 'pxelinux.0',
  dns_forward_max   => 1500,
  domain_needed     => true,
  bogus_priv        => true,
  no_negcache       => true,
  no_hosts          => true,
  resolv_file       => '/etc/resolv.conf',
  cache_size        => 1000,
  restart           => true,
}
```

Please refer to [dnsmasq man page](http://www.thekelleys.org.uk/dnsmasq/docs/dnsmasq-man.html) to get exact syntax and options

Core variables:

Variable      | Type          | Default | Description
------------- | ------------- | ------------ | -----------
$auth_sec_servers | String | undef | sec servers
$auth_server | String  | undef | Enable auth server mode
$auth_ttl | String | undef | Override TTL value of auth server
$auth_zone | String | undef | DNS zone for auth mode
$bogus_priv | Boolean | true | Bogus private reverse lookups
$cache_size | Boolean | 1000 | Size of dns cache
$config_hash | Array | undef | puppet config hash
$dhcp_boot | Boolean | true | Enable tftp booting
$dhcp_leasefile | Boolean | true | DHCP leases file location
$dhcp_no_override | Boolean | false | Disable re-use of the DHCP servername
$domain | String | undef | Network domain
$domain_needed | Boolean | false | Do not forward A/AAAA without domain part
$dns_forward_max | String | undef | maximum number of concurrent DNS queries
$enable_tftp | Boolean | undef | TFTP boot support
$expand_hosts | Boolean | true | Add the domain to simple names
$interface | String/Array | undef | Listening interface
$listen_address | String | undef | Listening IP address
$local_ttl | String | undef | Local time to live
$max_ttl | String | undef | Maximum time to live
$max_cache_ttl | String | undef | Maximum TTL for entries in cache
$neg_ttl | String | undef | Negative cache timeout
$no_dhcp_interface | String/Array | undef | Do not use DHCP on interface
$no_hosts | Boolean | false | Ignore /etc/hosts file
$no_negcache | Boolean | false | Do not cache negative responses
$no_resolv | Boolean | false | Ignore resolv.conf file
$port | String | 53 | Listening port
$read_ethers | Boolean | false | Read /etc/ethers for information about hosts
$reload_resolvconf | Boolean | true | Update resolvconf on changes
$resolv_file | Boolean | false | Location of resolv.conf file
$restart | Boolean | true | Restart on config change
$run_as_user | String | undef | force dnsmasq under specific user
$save_config_file | Boolean | true | Backup original config file
$service_enable | Boolean | true | Start dnsmasq at boot
$service_ensure | String | running | Ensure service state
$strict_order | Boolean | true | Use DNS servers order of resolv.conf
$tftp_root | String | /var/lib/tftpboot | Location of tftp boot files

There is also optional variables to override system-provided paths and names:

Variable      | Type          | Desc
------------- | ------------- | --------
$dnsmasq_confdir | String | Configuration directory location
$dnsmasq_conffile | String | Configuration file location
$dnsmasq_hasstatus | String | init.d status support
$dnsmasq_logdir | String | dnsmasq log directory
$dnsmasq_package | String | dnsmasq package name
$dnsmasq_package_provider | String | package system provider
$dnsmasq_service | String | Name of init.d service

### DHCP server configuration

Will add DHCP support to dnsmasq.
This can be used multiple times to setup multiple DHCP servers.
Parameter "set" is optional, this one makes use of tagging system in dnsmasq
Parameter "mode" is optional, please refer to dnsmasq man to see possible settings

```puppet
dnsmasq::dhcp { 'my-awesome-subnet':
  set        => 'hadoop0' # optional
  mode       => 'static' # optional
  dhcp_start => '192.168.1.100',
  dhcp_end   => '192.168.1.200',
  netmask    => '255.255.255.0',
  lease_time => '24h'
}
```

### Static DHCP record configuration

Will add static DHCP record to DHCP server with hostname.
Please be aware that example-host will also be used as DNS name.

```puppet
dnsmasq::config::dhcp_host { 'example-host':
  mac => 'DE:AD:BE:EF:CA:FE',
  ip  => '192.168.1.10',
}
```

### DHCP match configuration

Will add a dhcp match. Can be used for all types of options.
DHCP match will be inserted before 'DHCP option'.
It can be used multiple times.

```puppet
dnsmasq::config::dhcp_match {'example-match':
  content: 'IPXEBOOT,175'
}
```

### Host record configuration

Will add static A, AAAA (if provided) and PTR record

```puppet
dnsmasq::config::host_record { 'example-host-dns.int.lan':
  ipaddr => '192.168.1.20',
}
```
A more complex example would be:
```puppet
dnsmasq::config::host_record { 'example-host-dns.int.lan':
  host_record => ['example-host-dns', 'example-host-dns.int.lan'],
  ipaddr      => ['192.168.1.20', 'fe80:0000:0000:0000:0202:b3ff:fe1e:8329'],
}
```

### A record configuration

Will add static A record, this record will always override upstream data

```puppet
dnsmasq::config::address { 'example-host-dns.int.lan':
  ip => '192.168.1.20',
}
```

### CNAME records
Will add canonical name record.
Please note that dnsmasq cname is NOT regular cname and can be only for targets
which are names from DHCP leases or /etc/hosts, so it's more like alias for hostname

```puppet
dnsmasq::config::cname { 'mail':
  hostname => 'post',
}
```

### SRV records
Will add srv record which always overrides upstream data.
Priority argument is optional.

```puppet
dnsmasq::config::srv_host { '_ldap._tcp.example.com':
  target   => 'ldap-server.example.com',
  port     => 389,
  priority => 1,
}
```

### MX records
Will create MX (*M*ail e*X*change) record which always override upstream data

```puppet
dnsmasq::config::mx_host { 'maildomain.com':
  hostname   => 'mailserver.com',
  preference => 50,
}
```

### PTR records
Allows you to create PTR records for rDNS and DNS-SD.

```puppet
dnsmasq::config::ptr_record { '_http._tcp.dns-sd-services':
  value => '"New Employee Page._http._tcp.dns-sd-services"'
}
```

### TXT records
Allows you to create TXT records

```puppet
dnsmasq::config::txt_record { '_http._tcp.example.com':
  text => ['name=value','paper=A4'],
}
```

### DHCP option configuration

Will add dhcp option. Can be used for all types of options, ie:

* numeric ( option => '53' )
* ipv4-option ( option => 'option:router' )
* ipv6-option ( option => 'option6:dns-server' )

Can be used multiple times.

```puppet
dnsmasq::config::dhcp_option { 'my-awesome-dhcp-option':
  option  => 'option:router'
  content => '192.168.1.1',
  tag     => 'sometag', # optional
}
```

### DHCP booting (PXE)

Allows you to setup different PXE servers in different subnets.
tag is optional, you can use this to specify subnet for bootserver,
using tag you previously specified in dnsmasq::dhcp
Can be used multiple times.

```puppet
dnsmasq::config::dhcp_boot { 'hadoop-pxe':
  tag        => 'hadoop0',     # optional
  file       => 'pxelinux.0',
  hostname   => 'newoffice',   # optional
  bootserver => '192.168.39.1' # optional
}
```

### Per-subnet domain

Allows you to specify different domain for specific subnets.
Can be used multiple times.

```puppet
dnsmasq::config::domain { 'guests.company.lan':
  subnet => '192.168.196.0/24',
}
```

### DNS server
Configure the DNS server to query external DNS servers
```puppet
dnsmasq::config::server { ['8.8.8.8','8.8.4.4']:
}
```

Or, to query specific zone
```puppet
dnsmasq::config::server { '192.168.39.1':
  domain => ['foo.example.com','bar.example.com'],
  port   => 9001, # optional
}
```

### DNS-RR records
Allows dnsmasq to serve arbitrary records, for example:
```puppet
dnsmasq::config::dns_rr { 'example-sshfp':
    domain => 'example.com',
    type   => '44',
    rdata  => '2:1:123456789abcdef67890123456789abcdef67890'
}
```

### Running in Docker containers
When running in a Docker container, dnsmasq tries to drop root privileges. This causes the following error:
```
dnsmasq: setting capabilities failed: Operation not permitted
```

In this case you can use the run\_as\_user parameter to select the appropriate user to run as:
```puppet
class { 'dnsmasq':
  interface         => 'lo',
  listen_address    => '192.168.39.1',
  no_dhcp_interface => '192.168.49.1',
  ....
  run_as_user       => 'root',
}
```
