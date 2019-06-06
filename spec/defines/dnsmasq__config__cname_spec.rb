require 'spec_helper'

describe 'dnsmasq::config::cname', type: 'define' do
  let :title do
    'foo.com'
  end

  shared_context 'Supported Platform' do
    it do is_expected.not_to compile end
    it do
      is_expected.to raise_error(
        Puppet::Error, %r{expects a value for parameter 'target'}
      )
    end

    context 'with target' do
      let :params do
        { target: 'example.com' }
      end

      it do is_expected.to contain_class('dnsmasq') end
      it do
        is_expected.to contain_concat__fragment('dnsmasq-cname-foo.com').with(
          target: 'dnsmasq.conf',
          content: 'cname=foo.com,example.com',
        )
      end

      describe 'with ttl' do
        let :params do
          { target: 'example.com', ttl: 60 }
        end

        it do
          is_expected.to contain_concat__fragment('dnsmasq-cname-foo.com').with_content(
            'cname=foo.com,example.com,60',
          )
        end
      end

      describe 'with Array cname' do
        let :params do
          { target: 'example.com', cname: ['bar.com', 'baz.com'] }
        end

        it do
          is_expected.to contain_concat__fragment('dnsmasq-cname-foo.com').with_content(
            'cname=bar.com,baz.com,example.com',
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
