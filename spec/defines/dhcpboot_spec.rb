require 'spec_helper'

describe 'dnsmasq::dhcpboot', :type => 'define' do
  let :title  do 'foo' end
  let :facts  do {
    :concat_basedir  => '/foo/bar/baz',
    :osfamily        => 'Debian',
    :operatingsystem => 'Debian'
  } end

  context 'with minimal params' do
    let :params do {
      :file => '/foo',
    } end
    it do
      should contain_class('dnsmasq')
      should contain_concat__fragment('dnsmasq-dhcpboot-foo').with(
        :order   => '04',
        :target  => 'dnsmasq.conf',
        :content => "dhcp-boot=/foo\n",
      )
    end
  end

  context 'with all params' do
    let :params do {
      :file       => '/foo',
      :hostname   => 'example.com',
      :bootserver => '192.168.0.4',
      :tag   => 'bar',
    } end
    it do
      should contain_class('dnsmasq')
      should contain_concat__fragment('dnsmasq-dhcpboot-foo').with(
        :order   => '04',
        :target  => 'dnsmasq.conf',
        :content => "dhcp-boot=tag:bar,/foo,example.com,192.168.0.4\n",
      )
    end
  end
end
