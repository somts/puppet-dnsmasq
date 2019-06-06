require 'spec_helper'

describe 'dnsmasq::config::domain', type: 'define' do
  let :title do
    'example.com'
  end

  shared_context 'Supported Platform' do
    it do is_expected.to compile end
    it do is_expected.to contain_class('dnsmasq') end
    it do
      is_expected.to contain_concat__fragment('dnsmasq-domain-example.com').with(
        target: 'dnsmasq.conf',
        content: 'domain=example.com',
      )
    end

    context 'with subnet and local set' do
      let :params do
        { subnet: '192.168.0.0/24', local: true }
      end

      it do
        is_expected.to contain_concat__fragment('dnsmasq-domain-example.com').with(
          target: 'dnsmasq.conf',
          content: 'domain=example.com,192.168.0.0/24,local',
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
