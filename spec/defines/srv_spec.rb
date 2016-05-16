require 'spec_helper'

describe 'dnsmasq::srv', :type => 'define' do
  let :title  do '_xmpp-server._tcp.example.com' end
  let :facts  do {
    :concat_basedir  => '/foo/bar/baz',
    :osfamily        => 'Debian',
    :operatingsystem => 'Debian'
  } end

  context 'with minimal params' do
    let :params do {
      :hostname => 'example.com',
      :port     => '5333',
    } end
    it do
      should contain_class('dnsmasq')
      should contain_concat__fragment(
        'dnsmasq-srv-_xmpp-server._tcp.example.com').with(
        :order   => '09',
        :target  => 'dnsmasq.conf',
        :content => "srv-host=_xmpp-server._tcp.example.com,example.com,5333\n",
      )
    end
  end

  context 'with all params' do
    let :params do {
      :hostname => 'example.com',
      :port     => '5333',
      :priority => '10',
    } end
    it do
      should contain_class('dnsmasq')
      should contain_concat__fragment(
        'dnsmasq-srv-_xmpp-server._tcp.example.com').with(
        :order   => '09',
        :target  => 'dnsmasq.conf',
        :content =>
        "srv-host=_xmpp-server._tcp.example.com,example.com,5333,10\n",
      )
    end
  end
end
