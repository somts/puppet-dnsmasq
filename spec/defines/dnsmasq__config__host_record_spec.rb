require 'spec_helper'

describe 'dnsmasq::config::host_record', type: 'define' do
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

    context 'with ipaddr' do
      let :params do
        { ipaddr: '192.168.1.1' }
      end

      it do is_expected.to contain_class('dnsmasq') end
      it do
        is_expected.to contain_concat__fragment('dnsmasq-host-record-example.com').with(
          target: 'dnsmasq.conf',
          content: 'host-record=example.com,192.168.1.1',
        )
      end

      describe 'with ttl' do
        let :params do
          { ipaddr: '192.168.1.1', ttl: 60 }
        end

        it do
          is_expected.to contain_concat__fragment('dnsmasq-host-record-example.com').with(
            target: 'dnsmasq.conf',
            content: 'host-record=example.com,192.168.1.1,60',
          )
        end
      end

      describe 'with multiple fqdns' do
        let :params do
          { ipaddr: '192.168.1.1', host_record: ['foo.com', 'bar.com'] }
        end

        it do
          is_expected.to contain_concat__fragment('dnsmasq-host-record-example.com').with(
            target: 'dnsmasq.conf',
            content: 'host-record=foo.com,bar.com,192.168.1.1',
          )
        end
      end

      describe 'with IPv6 ipaddr' do
        let :params do
          { ipaddr: 'fe80::ad05:1248:a50d:8a8d' }
        end

        it do
          is_expected.to contain_concat__fragment('dnsmasq-host-record-example.com').with(
            target: 'dnsmasq.conf',
            content: 'host-record=example.com,fe80::ad05:1248:a50d:8a8d',
          )
        end
      end

      describe 'with IPv4 and IPv6 ipaddr' do
        let :params do
          { ipaddr: ['192.168.1.1', 'fe80::ad05:1248:a50d:8a8d'] }
        end

        it do
          is_expected.to contain_concat__fragment('dnsmasq-host-record-example.com').with(
            target: 'dnsmasq.conf',
            content: 'host-record=example.com,192.168.1.1,fe80::ad05:1248:a50d:8a8d',
          )
        end
      end

      describe 'with all the params' do
        let :params do
          {
            host_record: ['foo.com', 'bar.com'],
            ipaddr: ['192.168.1.1', 'fe80::ad05:1248:a50d:8a8d'],
            ttl: 60,
          }
        end

        it do
          is_expected.to contain_concat__fragment('dnsmasq-host-record-example.com').with(
            target: 'dnsmasq.conf',
            content: 'host-record=foo.com,bar.com,192.168.1.1,fe80::ad05:1248:a50d:8a8d,60',
          )
        end
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
