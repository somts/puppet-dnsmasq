require 'spec_helper'

describe 'dnsmasq::config::mx_host', type: 'define' do
  let :title do
    'example.com'
  end

  shared_context 'Supported Platform' do
    context 'with no params' do
      it do
        is_expected.to contain_class('dnsmasq')
      end
      it do
        is_expected.to contain_concat__fragment('dnsmasq-mx-host-example.com').with(
          target: 'dnsmasq.conf',
          content: 'mx-host=example.com',
        )
      end
    end

    context 'with all params' do
      let :params do
        {
          mx_name: 'my.example.com',
          hostname: 'example.com',
          preference: 50,
        }
      end

      it do
        is_expected.to contain_class('dnsmasq')
      end
      it do
        is_expected.to contain_concat__fragment('dnsmasq-mx-host-example.com').with(
          target: 'dnsmasq.conf',
          content: 'mx-host=my.example.com,example.com,50',
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
