require 'spec_helper'

describe 'dnsmasq::config::conf_file', type: 'define' do
  let :title do
    '/tmp/foo.conf'
  end

  # See metadata.json
  on_supported_os.sort.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      it do is_expected.to compile end
      it do is_expected.to contain_class('dnsmasq') end
      it do
        is_expected.to contain_concat__fragment('dnsmasq-conf-file-/tmp/foo.conf').with(
          target: 'dnsmasq.conf',
          content: 'conf-file=/tmp/foo.conf',
        )
      end
    end
  end
end
