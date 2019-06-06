require 'spec_helper'

describe 'dnsmasq::config::dns_rr', type: 'define' do
  let :title do
    'foo'
  end

  shared_context 'Supported Platform' do
    context 'with rr_number' do
      let :params do
        { rr_number: 51 }
      end

      it do is_expected.to contain_class('dnsmasq') end
      it do
        is_expected.to contain_concat__fragment('dnsmasq-dns-rr-foo').with(
          target: 'dnsmasq.conf',
          content: 'dns-rr=foo,51',
        )
      end

      describe 'with hex data' do
        let :params do
          { rr_number: 51, hex_data: '01 23 45' }
        end

        it do is_expected.to contain_class('dnsmasq') end
        it do
          is_expected.to contain_concat__fragment('dnsmasq-dns-rr-foo').with(
            target: 'dnsmasq.conf',
            content: 'dns-rr=foo,51,012345',
          )
        end
      end

      describe 'with different hex format' do
        let :params do
          { rr_number: 51, hex_data: '01:23:45' }
        end

        it do is_expected.to contain_class('dnsmasq') end
        it do
          is_expected.to contain_concat__fragment('dnsmasq-dns-rr-foo').with(
            target: 'dnsmasq.conf',
            content: 'dns-rr=foo,51,012345',
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
