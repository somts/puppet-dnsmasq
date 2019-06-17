require 'spec_helper'

describe 'dnsmasq::config::ptr_record', type: 'define' do
  let :title do
    'foo.com'
  end

  shared_context 'Supported Platform' do
    it do is_expected.to compile end
    it do is_expected.to contain_class('dnsmasq') end
    it do
      is_expected.to contain_concat__fragment('dnsmasq-ptr-record-foo.com').with(
        target: 'dnsmasq.conf',
        content: 'ptr-record=foo.com',
      )
    end

    context 'with target' do
      let :params do
        { target: 'example.com' }
      end

      it do
        is_expected.to contain_concat__fragment('dnsmasq-ptr-record-foo.com').with(
          target: 'dnsmasq.conf',
          content: 'ptr-record=foo.com,example.com',
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
