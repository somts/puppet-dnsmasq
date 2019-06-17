require 'spec_helper'

describe 'dnsmasq::config::dhcp_match', type: 'define' do
  let :title do
    'client-arch'
  end

  shared_context 'Supported Platform' do
    it do is_expected.not_to compile end
    it do
      is_expected.to raise_error(
        Puppet::Error, %r{expects a value for parameter 'set'}
      )
    end

    describe 'with parameter "set" set' do
      let :params do
        { set: 'efi-ia32' }
      end

      it do is_expected.to contain_class('dnsmasq') end
      it do
        is_expected.to contain_concat__fragment('dnsmasq-dhcp-match-client-arch').with(
          target: 'dnsmasq.conf',
          content: 'dhcp-match=set:efi-ia32,option:client-arch',
        )
      end

      context 'with "value" set' do
        let :params do
          { set: 'efi-ia32', value: 6 }
        end

        it do
          is_expected.to contain_concat__fragment('dnsmasq-dhcp-match-client-arch').with(
            target: 'dnsmasq.conf',
            content: 'dhcp-match=set:efi-ia32,option:client-arch,6',
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
