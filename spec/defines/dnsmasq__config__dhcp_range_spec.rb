require 'spec_helper'

describe 'dnsmasq::config::dhcp_range', type: 'define' do
  let :title do
    '192.168.0.128'
  end

  shared_context 'Supported Platform' do
    it do is_expected.to compile end
    it do is_expected.to contain_class('dnsmasq') end
    it do
      is_expected.to contain_concat__fragment('dnsmasq-dhcp-range-192.168.0.128').with(
        target: 'dnsmasq.conf',
        content: 'dhcp-range=192.168.0.128,1h',
      )
    end

    describe 'IPv4' do
      context 'with some tags' do
        let :params do
          { set: 'foo', tag: ['bar', 'baz'] }
        end

        it do
          is_expected.to contain_concat__fragment('dnsmasq-dhcp-range-192.168.0.128').with(
            target: 'dnsmasq.conf',
            content: 'dhcp-range=tag:bar,tag:baz,set:foo,192.168.0.128,1h',
          )
        end
      end

      context 'with mode set to static' do
        let :params do
          { mode: 'static', netmask: 24, lease_time: 'infinite' }
        end

        it do
          is_expected.to contain_concat__fragment('dnsmasq-dhcp-range-192.168.0.128').with(
            target: 'dnsmasq.conf',
            content: 'dhcp-range=192.168.0.128,static,24,infinite',
          )
        end
      end

      context 'with mode set to proxy' do
        let :params do
          { mode: 'proxy', netmask: '255.255.255.128' }
        end

        it do
          is_expected.to contain_concat__fragment('dnsmasq-dhcp-range-192.168.0.128').with(
            target: 'dnsmasq.conf',
            content: 'dhcp-range=192.168.0.128,proxy,255.255.255.128,1h',
          )
        end
      end

      context 'with start_addr and end_addr' do
        let :params do
          {
            start_addr: '10.20.30.128',
            end_addr: '10.20.30.192',
            netmask: '255.255.255.0',
            lease_time: '8h',
          }
        end

        it do
          is_expected.to contain_concat__fragment('dnsmasq-dhcp-range-192.168.0.128').with(
            target: 'dnsmasq.conf',
            content: 'dhcp-range=10.20.30.128,10.20.30.192,255.255.255.0,8h',
          )
        end
      end
    end
    # IPv4

    describe 'IPv6' do
      let :title do
        'fe80:0000:0000:0000:ad05:1240:0000:0001'
      end

      context 'with mode set to static' do
        let :params do
          { mode: 'static', start_addr: '::' }
        end

        it do
          is_expected.to contain_concat__fragment('dnsmasq-dhcp-range-fe80:0000:0000:0000:ad05:1240:0000:0001').with(
            target: 'dnsmasq.conf',
            content: 'dhcp-range=::,static,1h',
          )
        end
      end

      context 'with start_addr and end_addr (compressed versions)' do
        let :params do
          {
            start_addr: 'fe80::ad05:1240:0:1',
            end_addr: 'fe80::ad05:1241:ffff:fffe',
            prefix_len: 95,
            lease_time: '45m',
          }
        end

        it do
          is_expected.to contain_concat__fragment('dnsmasq-dhcp-range-fe80:0000:0000:0000:ad05:1240:0000:0001').with(
            target: 'dnsmasq.conf',
            content: 'dhcp-range=fe80::ad05:1240:0:1,fe80::ad05:1241:ffff:fffe,95,45m',
          )
        end
      end

      context 'with constructor' do
        let :params do
          { start_addr: '::', constructor: 'eth0' }
        end

        it do
          is_expected.to contain_concat__fragment('dnsmasq-dhcp-range-fe80:0000:0000:0000:ad05:1240:0000:0001').with(
            target: 'dnsmasq.conf',
            content: 'dhcp-range=::,constructor:eth0,1h',
          )
        end
      end

      context 'with another constructor' do
        let :params do
          { start_addr: '::1', end_addr: '::400', constructor: 'eth0' }
        end

        it do
          is_expected.to contain_concat__fragment('dnsmasq-dhcp-range-fe80:0000:0000:0000:ad05:1240:0000:0001').with(
            target: 'dnsmasq.conf',
            content: 'dhcp-range=::1,::400,constructor:eth0,1h',
          )
        end
      end
    end
    # IPv6
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
