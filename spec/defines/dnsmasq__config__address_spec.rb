require 'spec_helper'

describe 'dnsmasq::config::address', type: 'define' do
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
        { ipaddr: '0.0.0.0' }
      end

      it do is_expected.to contain_class('dnsmasq') end
      it do
        is_expected.to contain_concat__fragment('dnsmasq-address-example.com').with(
          target: 'dnsmasq.conf',
          content: 'address=/example.com/0.0.0.0',
        )
      end

      describe 'with array of addresses' do
        let :params do
          { ipaddr: '0.0.0.0', address: ['foo.com', 'bar.com'] }
        end

        it do
          is_expected.to contain_concat__fragment('dnsmasq-address-example.com').with(
            target: 'dnsmasq.conf',
            content: 'address=/foo.com/bar.com/0.0.0.0',
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
