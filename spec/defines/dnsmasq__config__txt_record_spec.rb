require 'spec_helper'

describe 'dnsmasq::config::txt_record', type: 'define' do
  let :title do
    'example.com'
  end

  shared_context 'Supported Platform' do
    it do is_expected.not_to compile end
    it do
      is_expected.to raise_error(
        Puppet::Error, %r{expects a value for parameter 'text'}
      )
    end

    context 'with text parameter set' do
      let :params do
        { text: 'v=spf1 mx a ip4:192.168.0.1' }
      end

      it do is_expected.to contain_class('dnsmasq') end
      it do
        is_expected.to contain_concat__fragment('dnsmasq-txt-record-example.com').with(
          target: 'dnsmasq.conf',
          content: 'txt-record=example.com,"v=spf1 mx a ip4:192.168.0.1"',
        )
      end
    end

    context 'with multiple text parameter values' do
      let :params do
        { text: ['v=spf1 mx a ip4:192.168.0.1', 'v=spf1 mx a ip4:192.168.1.1'] }
      end

      it do is_expected.to contain_class('dnsmasq') end
      it do
        is_expected.to contain_concat__fragment('dnsmasq-txt-record-example.com').with(
          target: 'dnsmasq.conf',
          content: 'txt-record=example.com,"v=spf1 mx a ip4:192.168.0.1","v=spf1 mx a ip4:192.168.1.1"',
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
