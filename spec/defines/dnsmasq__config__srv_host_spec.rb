require 'spec_helper'

describe 'dnsmasq::config::srv_host', type: 'define' do
  let :title do
    '_xmpp-server._tcp'
  end

  shared_context 'Supported Platform' do
    it do is_expected.to compile end
    it do is_expected.to contain_class('dnsmasq') end
    it do
      is_expected.to contain_concat__fragment('dnsmasq-srv-host-_xmpp-server._tcp').with(
        target: 'dnsmasq.conf',
        content: 'srv-host=_xmpp-server._tcp',
      )
    end

    context 'with modest params set' do
      let :params do
        { target: 'xmpp.example.com', port: 5333 }
      end

      it do
        is_expected.to contain_concat__fragment('dnsmasq-srv-host-_xmpp-server._tcp').with(
          target: 'dnsmasq.conf',
          content: 'srv-host=_xmpp-server._tcp,xmpp.example.com,5333',
        )
      end
    end

    context 'with all params set' do
      let :params do
        {
          service: '_xmpp-server._udp',
          domain: 'example.com',
          target: 'xmpp.example.com',
          port: 5333,
          priority: 10,
          weight: 20,
        }
      end

      it do
        is_expected.to contain_concat__fragment('dnsmasq-srv-host-_xmpp-server._tcp').with(
          target: 'dnsmasq.conf',
          content: 'srv-host=_xmpp-server._udp.example.com,xmpp.example.com,5333,10,20',
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
