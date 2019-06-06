require 'spec_helper' # frozen_string_literal: true

describe 'dnsmasq::install', type: :class do
  # See metadata.json
  on_supported_os.sort.each do |os, facts|
    context "on #{os}" do
      let :facts do
        facts
      end

      it do is_expected.not_to compile end
      it do
        is_expected.to raise_error(
          Puppet::Error, %r{Use of private class dnsmasq::install by }
        )
      end
    end
  end
end
