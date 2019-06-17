require 'spec_helper'

describe 'dnsmasq::config::dhcp_option', type: 'define' do
  let :title do
    'option:ntp-server'
  end

  shared_context 'Supported Platform' do
    it do is_expected.not_to compile end
    it do
      is_expected.to raise_error(
        Puppet::Error, %r{expects a value for parameter 'value'}
      )
    end

    context 'with minimal params' do
      let :params do
        { value: '192.168.0.4' }
      end

      it do is_expected.to contain_class('dnsmasq') end
      it do
        is_expected.to contain_concat__fragment('dnsmasq-dhcp-option-option:ntp-server').with(
          target: 'dnsmasq.conf',
          content: 'dhcp-option=option:ntp-server,192.168.0.4',
        )
      end
    end

    context 'with all params' do
      let :params do
        {
          value: '[::]',
          tag: ['foo', 'bar'],
          encap: 175,
          vi_encap: 2,
          vendor: 'PXEClient',
          option: 'option6:ntp-server',
          force: true,
        }
      end

      it do is_expected.to contain_class('dnsmasq') end
      it do
        is_expected.to contain_concat__fragment('dnsmasq-dhcp-option-force-option:ntp-server').with(
          target: 'dnsmasq.conf',
          content: 'dhcp-option-force=tag:foo,tag:bar,encap:175,vi-encap:2,vendor:PXEClient,option6:ntp-server,[::]',
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
