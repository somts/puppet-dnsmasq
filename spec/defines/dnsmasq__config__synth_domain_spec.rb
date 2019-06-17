require 'spec_helper'

describe 'dnsmasq::config::synth_domain', type: 'define' do
  let :title do
    'example.com'
  end

  shared_context 'Supported Platform' do
    it do is_expected.not_to compile end
    it do
      is_expected.to raise_error(
        Puppet::Error, %r{expects a value for parameter '}
      )
    end

    context 'with address range and prefix params' do
      let :params do
        {
          address_range: ['192.168.0.64', '192.168.0.128'],
          prefix: 'internal-*',
        }
      end

      it do is_expected.to compile end
      it do is_expected.to contain_class('dnsmasq') end
      it do
        is_expected.to contain_concat__fragment('dnsmasq-synth-domain-example.com').with(
          target: 'dnsmasq.conf',
          content: 'synth-domain=example.com,192.168.0.64,192.168.0.128,internal-*',
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
