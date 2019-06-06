# Private class. Manage dnsmasq config
class dnsmasq::config {
  ## VALIDATION

  if $caller_module_name != $module_name {
    fail("Use of private class ${name} by ${caller_module_name}")
  }

  ## CLASS VARIABLES

  $dhcp_alternate_port = $dnsmasq::dhcp_alternate_port_server ? {
    undef   =>  undef,
    default => $dnsmasq::dhcp_alternate_port_client ? {
      undef => join([
        $dnsmasq::dhcp_alternate_port_server,
        $dnsmasq::dhcp_alternate_port_server + 1,
      ],','),
      default => join([
        $dnsmasq::dhcp_alternate_port_server,
        $dnsmasq::dhcp_alternate_port_client,
      ],','),
    }
  }

  # Render --tftp-port-range if both start and end are defined.
  # Otherwise, make undef
  $tftp_port_range = $dnsmasq::tftp_port_range_start ? {
    undef   => undef,
    default => $dnsmasq::tftp_port_range_end ? {
      undef   => undef,
      default => join([
        $dnsmasq::tftp_port_range_start,
        $dnsmasq::tftp_port_range_end,
      ], ','),
    },
  }

  $config_hash = delete_undef_values({
    'add-cpe-id'            => $dnsmasq::add_cpe_id,
    'add-mac'               => $dnsmasq::add_mac,
    'addn-hosts'            => $dnsmasq::addn_hosts,
    'all-servers'           => $dnsmasq::all_servers,
    'auth-peer'             => $dnsmasq::auth_peer,
    'auth-sec-servers'      => $dnsmasq::auth_sec_servers,
    'auth-server'           => $dnsmasq::auth_server,
    'auth-soa'              => $dnsmasq::auth_soa,
    'auth-ttl'              => $dnsmasq::auth_ttl,
    'auth-zone'             => $dnsmasq::auth_zone,
    'bind-dynamic'          => $dnsmasq::bind_dynamic,
    'bind-interfaces'       => $dnsmasq::bind_interfaces,
    'bogus-nxdomain'        => $dnsmasq::bogus_nxdomain,
    'bogus-priv'            => $dnsmasq::bogus_priv,
    'bootp-dynamic'         => join(flatten([$dnsmasq::bootp_dynamic]), ','),
    'bridge-interface'      => $dnsmasq::bridge_interface,
    'cache-size'            => $dnsmasq::cache_size,
    'clear-on-reload'       => $dnsmasq::clear_on_reload,
    'conf-file'             => $dnsmasq::conf_file,
    'conntrack'             => $dnsmasq::conntrack,
    'dhcp-alternate-port'   => $dhcp_alternate_port,
    'dhcp-authoritative'    => $dnsmasq::dhcp_authoritative,
    'dhcp-boot'             => $dnsmasq::dhcp_boot,
    'dhcp-broadcast'        => $dnsmasq::dhcp_broadcast,
    'dhcp-circuitid'        => $dnsmasq::dhcp_circuitid,
    'dhcp-client-update'    => $dnsmasq::dhcp_client_update,
    'dhcp-duid'             => $dnsmasq::dhcp_duid,
    'dhcp-fqdn'             => $dnsmasq::dhcp_fqdn,
    'dhcp-generate-names'   => $dnsmasq::dhcp_generate_names,
    'dhcp-hostsdir'         => $dnsmasq::dhcp_hostsdir,
    'dhcp-hostsfile'        => $dnsmasq::dhcp_hostsfile,
    'dhcp-ignore'           => $dnsmasq::dhcp_ignore,
    'dhcp-ignore-names'     => $dnsmasq::dhcp_ignore_names,
    'dhcp-leasefile'        => $dnsmasq::dhcp_leasefile,
    'dhcp-lease-max'        => $dnsmasq::dhcp_lease_max,
    'dhcp-luascript'        => $dnsmasq::dhcp_luascript,
    'dhcp-mac'              => $dnsmasq::dhcp_mac,
    'dhcp-match'            => $dnsmasq::dhcp_match,
    'dhcp-no-override'      => $dnsmasq::dhcp_no_override,
    'dhcp-optsdir'          => $dnsmasq::dhcp_optsdir,
    'dhcp-optsfile'         => $dnsmasq::dhcp_optsfile,
    'dhcp-proxy'            => $dnsmasq::dhcp_proxy,
    'dhcp-relay'            => $dnsmasq::dhcp_relay,
    'dhcp-remoteid'         => $dnsmasq::dhcp_remoteid,
    'dhcp-script'           => $dnsmasq::dhcp_script,
    'dhcp-scriptuser'       => $dnsmasq::dhcp_scriptuser,
    'dhcp-sequential-ip'    => $dnsmasq::dhcp_sequential_ip,
    'dhcp-subscrid'         => $dnsmasq::dhcp_subscrid,
    'dhcp-ttl'              => $dnsmasq::dhcp_ttl,
    'dhcp-userclass'        => $dnsmasq::dhcp_userclass,
    'dhcp-vendorclass'      => $dnsmasq::dhcp_vendorclass,
    'dns-forward-max'       => $dnsmasq::dns_forward_max,
    'dns-loop-detect'       => $dnsmasq::dns_loop_detect,
    'dnssec'                => $dnsmasq::dnssec,
    'dnssec-check-unsigned' => $dnsmasq::dnssec_check_unsigned,
    'dnssec-debug'          => $dnsmasq::dnssec_debug,
    'dnssec-no-timecheck'   => $dnsmasq::dnssec_no_timecheck,
    'dnssec-timestamp'      => $dnsmasq::dnssec_timestamp,
    'domain-needed'         => $dnsmasq::domain_needed,
    'edns-packet-max'       => $dnsmasq::edns_packet_max,
    'enable-dbus'           => $dnsmasq::enable_dbus,
    'enable-ra'             => $dnsmasq::enable_ra,
    'enable-tftp'           => $dnsmasq::enable_tftp,
    'except-interface'      => $dnsmasq::except_interface,
    'expand-hosts'          => $dnsmasq::expand_hosts,
    'filterwin2k'           => $dnsmasq::filterwin2k,
    'group'                 => $dnsmasq::group,
    'hostsdir'              => $dnsmasq::hostsdir,
    'interface'             => $dnsmasq::interface,
    'interface-name'        => $dnsmasq::interface_name,
    'ipset'                 => $dnsmasq::ipset,
    'keep-in-foreground'    => $dnsmasq::keep_in_foreground,
    'leasefile-ro'          => $dnsmasq::leasefile_ro,
    'listen-address'        => $dnsmasq::listen_address,
    'localise-queries'      => $dnsmasq::localise_queries,
    'local'                 => $dnsmasq::local,
    'localmx'               => $dnsmasq::localmx,
    'local-service'         => $dnsmasq::local_service,
    'local-ttl'             => $dnsmasq::local_ttl,
    'log-async'             => $dnsmasq::log_async,
    'log-dhcp'              => $dnsmasq::log_dhcp,
    'log-facility'          => $dnsmasq::log_facility,
    'log-queries'           => $dnsmasq::log_queries,
    'max-cache-ttl'         => $dnsmasq::max_cache_ttl,
    'max-port'              => $dnsmasq::max_port,
    'max-ttl'               => $dnsmasq::max_ttl,
    'min-cache-ttl'         => $dnsmasq::min_cache_ttl,
    'min-port'              => $dnsmasq::min_port,
    'mx-host'               => $dnsmasq::mx_host,
    'mx-target'             => $dnsmasq::mx_target,
    'naptr-record'          => $dnsmasq::naptr_record,
    'neg-ttl'               => $dnsmasq::neg_ttl,
    'no-daemon'             => $dnsmasq::no_daemon,
    'no-dhcp-interface'     => $dnsmasq::no_dhcp_interface,
    'no-hosts'              => $dnsmasq::no_hosts,
    'no-negcache'           => $dnsmasq::no_negcache,
    'no-ping'               => $dnsmasq::no_ping,
    'no-poll'               => $dnsmasq::no_poll,
    'no-resolv'             => $dnsmasq::no_resolv,
    'pid-file'              => $dnsmasq::pid_file,
    'port'                  => $dnsmasq::port,
    'proxy-dnssec'          => $dnsmasq::proxy_dnssec,
    'pxe-prompt'            => $dnsmasq::pxe_prompt,
    'pxe-service'           => $dnsmasq::pxe_service,
    'query-port'            => $dnsmasq::query_port,
    'quiet-dhcp6'           => $dnsmasq::quiet_dhcp6,
    'quiet-dhcp'            => $dnsmasq::quiet_dhcp,
    'quiet-ra'              => $dnsmasq::quiet_ra,
    'read-ethers'           => $dnsmasq::read_ethers,
    'rebind-domain-ok'      => $dnsmasq::rebind_domain_ok,
    'rebind-localhost-ok'   => $dnsmasq::rebind_localhost_ok,
    'resolv-file'           => $dnsmasq::resolv_file,
    'rev-server'            => $dnsmasq::rev_server,
    'script-arp'            => $dnsmasq::script_arp,
    'selfmx'                => $dnsmasq::selfmx,
    'servers-file'          => $dnsmasq::servers_file,
    'stop-dns-rebind'       => $dnsmasq::stop_dns_rebind,
    'strict-order'          => $dnsmasq::strict_order,
    'synth-domain'          => $dnsmasq::synth_domain,
    'tag-if'                => $dnsmasq::tag_if,
    'tftp-lowercase'        => $dnsmasq::tftp_lowercase,
    'tftp-max'              => $dnsmasq::tftp_max,
    'tftp-mtu'              => $dnsmasq::tftp_mtu,
    'tftp-no-blocksize'     => $dnsmasq::tftp_no_blocksize,
    'tftp-no-fail'          => $dnsmasq::tftp_no_fail,
    'tftp-port-range'       => $tftp_port_range,
    'tftp-root'             => $dnsmasq::tftp_root,
    'tftp-secure'           => $dnsmasq::tftp_secure,
    'tftp-unique-root'      => $dnsmasq::tftp_unique_root,
    'trust-anchor'          => $dnsmasq::trust_anchor,
  }) + $dnsmasq::config_hash

  ## MANAGED RESOURCES

  file {
    $dnsmasq::dnsmasq_conf_dir :
      ensure       => 'directory',
      owner        => 0,
      group        => 0,
      mode         => '0755',
      recurse      => true,
      recurselimit => 1,
      purge        => true,;
    $dnsmasq::dnsmasq_logdir :
      ensure => 'directory',
      owner  => 0,
      group  => 0,
      mode   => '0755',;
  }

  concat { 'dnsmasq.conf':
    path           => $dnsmasq::dnsmasq_conf_file,
    ensure_newline => true,
    warn           => true,
    owner          => 0,
    group          => 0,
    mode           => '0644',
  }

  concat::fragment { 'dnsmasq.conf_top':
    order   => '00',
    target  => 'dnsmasq.conf',
    content => template('dnsmasq/dnsmasq.conf.erb'),
  }

  dnsmasq::config::conf_dir { $dnsmasq::dnsmasq_conf_dir:
    require => File[$dnsmasq::dnsmasq_conf_dir],
  }

  if $dnsmasq::reload_resolvconf {
    exec { 'reload_resolvconf':
      provider => 'shell',
      command  => '/sbin/resolvconf -u',
      path     => [ '/usr/bin', '/usr/sbin', '/bin', '/sbin', ],
      user     => 'root',
      onlyif   => 'test -x /sbin/resolvconf',
    }
  }

  if $dnsmasq::manage_tftp_root {
    file { $dnsmasq::tftp_root:
      ensure => 'directory',
      owner  => 0,
      group  => 0,
      mode   => '0755',
    }
  }

  #if ! $dnsmasq::no_hosts {
  #  Host <||> {
  #    notify +> Class['dnsmasq::service'],
  #  }
  #}

  # Create resources from specificied Hashs
  create_resources('dnsmasq::config::address', $dnsmasq::addresses)
  create_resources('dnsmasq::config::add_subnet', $dnsmasq::add_subnets)
  create_resources('dnsmasq::config::alias', $dnsmasq::aliases)
  create_resources('dnsmasq::config::cname', $dnsmasq::cnames)
  create_resources('dnsmasq::config::conf_dir', $dnsmasq::conf_dirs)
  create_resources('dnsmasq::config::dhcp_boot', $dnsmasq::dhcp_boots)
  create_resources('dnsmasq::config::dhcp_host', $dnsmasq::dhcp_hosts)
  create_resources('dnsmasq::config::dhcp_match', $dnsmasq::dhcp_matches)
  create_resources('dnsmasq::config::dhcp_option', $dnsmasq::dhcp_options)
  create_resources('dnsmasq::config::dhcp_range', $dnsmasq::dhcp_ranges)
  create_resources('dnsmasq::config::dns_rr', $dnsmasq::dns_rrs)
  create_resources('dnsmasq::config::domain', $dnsmasq::domains)
  create_resources('dnsmasq::config::host_record', $dnsmasq::host_records)
  create_resources('dnsmasq::config::mx_host', $dnsmasq::mx_hosts)
  create_resources('dnsmasq::config::ptr_record', $dnsmasq::ptr_records)
  create_resources('dnsmasq::config::server', $dnsmasq::servers)
  create_resources('dnsmasq::config::srv_host', $dnsmasq::srv_hosts)
  create_resources('dnsmasq::config::txt_record', $dnsmasq::txt_records)
}
