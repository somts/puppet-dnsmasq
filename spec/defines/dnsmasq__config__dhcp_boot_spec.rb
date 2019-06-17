require 'spec_helper'

describe 'dnsmasq::config::dhcp_boot', type: 'define' do
  let :title do
    'pxelinux.0'
  end

  shared_context 'Supported Platform' do
    it do is_expected.to compile end
    it do is_expected.to contain_class('dnsmasq') end
    it do
      is_expected.to contain_concat__fragment('dnsmasq-dhcp-boot-pxelinux.0').with(
        target: 'dnsmasq.conf',
        content: 'dhcp-boot=pxelinux.0',
      )
    end

    context 'with all params' do
      let :params do
        {
          file: '/pxelinux.0',
          servername: 'example.com',
          server_address: '192.168.0.4',
          tag: 'bar',
        }
      end

      it do is_expected.to contain_class('dnsmasq') end
      it do
        is_expected.to contain_concat__fragment('dnsmasq-dhcp-boot-pxelinux.0').with(
          target: 'dnsmasq.conf',
          content: 'dhcp-boot=tag:bar,/pxelinux.0,example.com,192.168.0.4',
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
