require 'spec_helper'

describe 'dnsmasq::config::dhcp_host', type: 'define' do
  let :title do
    'example.com'
  end

  shared_context 'Supported Platform' do
    it do is_expected.not_to compile end
    it do
      is_expected.to raise_error(
        Puppet::Error, %r{expects a value for parameter 'ipaddr'}
      )
    end

    context 'with IPv4 params' do
      let :params do
        { hwaddr: '4C:72:B9:31:8C:B9', ipaddr: '192.168.0.4' }
      end

      it do is_expected.to contain_class('dnsmasq') end
      it do
        is_expected.to contain_concat__fragment('dnsmasq-dhcp-host-example.com').with(
          target: 'dnsmasq.conf',
          content: 'dhcp-host=4c:72:b9:31:8c:b9,192.168.0.4,example.com',
        )
      end
    end

    context 'with IPv6 params' do
      let :params do
        { hwaddr: '4C:72:B9:31:8C:B9', ipaddr: 'FE80::AD05:1248:A50D:8A8D' }
      end

      it do is_expected.to contain_class('dnsmasq') end
      it do
        is_expected.to contain_concat__fragment('dnsmasq-dhcp-host-example.com').with(
          target: 'dnsmasq.conf',
          content: 'dhcp-host=4c:72:b9:31:8c:b9,[fe80::ad05:1248:a50d:8a8d],example.com',
        )
      end
    end

    context 'with all params' do
      let :params do
        {
          hwaddr: '4c:72:b9:31:8c:b9',
          ipaddr: 'fe80::ad05:1248:a50d:8a8d',
          ignore: true,
          id: '*',
          set: 'foo',
          lease_time: 'infinite',
          hostname: 'foo.org',
        }
      end

      it do is_expected.to contain_class('dnsmasq') end
      it do
        is_expected.to contain_concat__fragment('dnsmasq-dhcp-host-example.com').with(
          target: 'dnsmasq.conf',
          content: 'dhcp-host=4c:72:b9:31:8c:b9,id:*,set:foo,[fe80::ad05:1248:a50d:8a8d],foo.org,infinite,ignore',
        )
      end
    end
  end

  # See metadata.json
  on_supported_os.sort.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      include_context 'Supported Platform'
    end
  end
end
