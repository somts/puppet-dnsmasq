require 'spec_helper'

describe 'dnsmasq::dhcpstatic', :type => 'define' do
  let :title  do 'example.com' end
  let :facts  do {
    :concat_basedir  => '/foo/bar/baz',
    :osfamily        => 'Debian',
    :operatingsystem => 'Debian'
  } end

  context 'with params' do
    let :params do {
      :mac => '4C:72:B9:31:8C:B9',
      :ip  => '192.168.0.4',
    } end
    it do
      should contain_class('dnsmasq')
      should contain_concat__fragment('dnsmasq-staticdhcp-example.com'
                                     ).with(
        :order   => '05',
        :target  => 'dnsmasq.conf',
        :content => "dhcp-host=4c:72:b9:31:8c:b9,192.168.0.4,example.com\n",
      )
    end
  end

end
