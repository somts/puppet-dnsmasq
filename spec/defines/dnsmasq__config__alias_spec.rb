require 'spec_helper'

describe 'dnsmasq::config::alias', type: 'define' do
  let :title do
    '6.7.8.0'
  end

  shared_context 'Supported Platform' do
    it do is_expected.not_to compile end
    it do
      is_expected.to raise_error(
        Puppet::Error, %r{expects a value for parameter 'old_ip'}
      )
    end

    context 'with old_ip' do
      let :params do
        { old_ip: '1.2.3.0' }
      end

      it do is_expected.to contain_class('dnsmasq') end
      it do
        is_expected.to contain_concat__fragment('dnsmasq-alias-6.7.8.0').with(
          target: 'dnsmasq.conf',
          content: 'alias=1.2.3.0,6.7.8.0',
        )
      end

      describe 'with a netmask' do
        let :params do
          { old_ip: '1.2.3.0', mask: '255.255.255.0' }
        end

        it do
          is_expected.to contain_concat__fragment('dnsmasq-alias-6.7.8.0').with(
            target: 'dnsmasq.conf',
            content: 'alias=1.2.3.0,6.7.8.0,255.255.255.0',
          )
        end
      end

      describe 'with old_ip as range and other params per manpage example' do
        let :params do
          {
            old_ip: ['192.168.0.10', '192.168.0.40'],
            new_ip: '10.0.0.0',
            mask: '255.255.255.0',
          }
        end

        it do
          is_expected.to contain_concat__fragment('dnsmasq-alias-6.7.8.0').with(
            target: 'dnsmasq.conf',
            content: 'alias=192.168.0.10-192.168.0.40,10.0.0.0,255.255.255.0',
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
