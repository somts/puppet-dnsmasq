require 'spec_helper'

describe 'dnsmasq::config::server', :type => 'define' do
  let :title do
    '192.168.1.1'
  end

  shared_context 'Supported Platform' do
    it do is_expected.to compile end
    it do is_expected.to contain_class('dnsmasq') end
    it do
      is_expected.to contain_concat__fragment('dnsmasq-server-192.168.1.1').with(
        target: 'dnsmasq.conf',
        content: 'server=192.168.1.1',
      )
    end

    context 'with port' do
      let :params do
        { port: 5353 }
      end

      it do
        is_expected.to contain_concat__fragment('dnsmasq-server-192.168.1.1').with(
          target: 'dnsmasq.conf',
          content: 'server=192.168.1.1#5353',
        )
      end
    end

    context 'with domain' do
      let :params do
        { domain: 'example.com' }
      end

      it do
        is_expected.to contain_concat__fragment('dnsmasq-server-192.168.1.1').with(
          target: 'dnsmasq.conf',
          content: 'server=/example.com/192.168.1.1',
        )
      end
    end

    context 'with domains' do
      let :params do
        { domain: ['foo.com', 'bar.com'] }
      end

      it do
        is_expected.to contain_concat__fragment('dnsmasq-server-192.168.1.1').with(
          target: 'dnsmasq.conf',
          content: 'server=/foo.com/bar.com/192.168.1.1',
        )
      end
    end

    context 'with domains and port' do
      let :params do
        { domain: ['foo.com', 'bar.com'], port: 5353 }
      end

      it do
        is_expected.to contain_concat__fragment('dnsmasq-server-192.168.1.1').with(
          target: 'dnsmasq.conf',
          content: 'server=/foo.com/bar.com/192.168.1.1#5353',
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
