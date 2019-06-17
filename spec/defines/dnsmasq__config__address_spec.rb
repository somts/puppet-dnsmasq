require 'spec_helper'

describe 'dnsmasq::config::address', type: 'define' do
  let :title do
    'example.com'
  end

  shared_context 'Supported Platform' do
    it do is_expected.to compile end
    it do is_expected.to contain_class('dnsmasq') end
    it do
      is_expected.to contain_concat__fragment('dnsmasq-address-example.com').with(
        target: 'dnsmasq.conf',
        content: 'address=/example.com/',
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

      describe 'with special ipaddr "#"' do
        let :params do
          { ipaddr: '#' }
        end

        it do
          is_expected.to contain_concat__fragment('dnsmasq-address-example.com').with(
            target: 'dnsmasq.conf',
            content: 'address=/example.com/#',
          )
        end
      end

      describe 'with array of domains' do
        let :params do
          { ipaddr: '0.0.0.0', domain: ['foo.com', 'bar.com'] }
        end

        it do
          is_expected.to contain_concat__fragment('dnsmasq-address-example.com').with(
            target: 'dnsmasq.conf',
            content: 'address=/foo.com/bar.com/0.0.0.0',
          )
        end
      end

      describe 'with special domain "#"' do
        let :params do
          { ipaddr: '1.2.3.4', domain: '#' }
        end

        it do
          is_expected.to contain_concat__fragment('dnsmasq-address-example.com').with(
            target: 'dnsmasq.conf',
            content: 'address=/#/1.2.3.4',
          )
        end

        describe 'with special domain "#" and special ipaddr "#"' do
          let :params do
            { ipaddr: '#', domain: '#' }
          end

          it do is_expected.not_to compile end
          it do
            is_expected.to raise_error(
              Puppet::Error, %r{domain cannot be "#" when ipaddr is "#"}
            )
          end
        end

        describe 'with special domain "#" and ipaddr undef' do
          let :params do
            { domain: '#' }
          end

          it do is_expected.not_to compile end
          it do
            is_expected.to raise_error(
              Puppet::Error, %r{domain cannot be "#" when ipaddr is unset}
            )
          end
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
