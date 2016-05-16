require 'spec_helper'

describe 'dnsmasq::dhcpoption', :type => 'define' do
  let :title  do 'option:ntp-server' end
  let :facts  do {
    :concat_basedir  => '/foo/bar/baz',
    :osfamily        => 'Debian',
    :operatingsystem => 'Debian'
  } end

  context 'with minimal parms' do
    let :params do {
      :content => '192.168.0.4',
      :option  => 'option:ntp-server'
    } end
    it do
      should contain_class('dnsmasq')
      should contain_concat__fragment('dnsmasq-dhcpoption-option:ntp-server'
                                     ).with(
        :order   => '03',
        :target  => 'dnsmasq.conf',
        :content => "dhcp-option=option:ntp-server,192.168.0.4\n",
      )
    end
  end

  context 'with all parms' do
    let :params do {
      :content  => '192.168.0.4',
      :tag      => 'foo',
      :option   => 'option:ntp-server'
    } end
    it do
      should contain_class('dnsmasq')
      should contain_concat__fragment('dnsmasq-dhcpoption-option:ntp-server'
                                     ).with(
        :order   => '03',
        :target  => 'dnsmasq.conf',
        :content => "dhcp-option=tag:foo,option:ntp-server,192.168.0.4\n",
      )
    end
  end

end
