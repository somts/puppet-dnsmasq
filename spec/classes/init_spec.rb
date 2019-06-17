require 'spec_helper' # frozen_string_literal: true

describe 'dnsmasq', type: :class do
  shared_context 'Supported Platform' do
    it do is_expected.to compile.with_all_deps end
    it do is_expected.to contain_class('dnsmasq::install').that_comes_before('Class[dnsmasq::config]') end
    it do is_expected.to contain_class('dnsmasq::config').that_notifies('Class[dnsmasq::service]') end
    it do is_expected.to contain_class('dnsmasq::service') end

    describe 'dnsmasq::install' do
      context 'should allow package ensure to be overridden' do
        let :params do
          { package_name: 'dnsmasq', package_ensure: 'latest' }
        end

        it do is_expected.to contain_package('dnsmasq').with_ensure('latest') end
      end

      context 'should allow the package name to be overridden' do
        let :params do
          { package_name: 'foo' }
        end

        it do is_expected.to contain_package('foo') end
      end

      context 'should allow the package name to be an array of names' do
        let :params do
          { package_name: ['foo', 'bar'] }
        end

        it do is_expected.to contain_package('foo') end
        it do is_expected.to contain_package('bar') end
      end

      context 'should allow the package to be unmanaged' do
        let :params do
          { package_name: 'dnsmasq', package_manage: false }
        end

        it do is_expected.not_to contain_package('dnsmasq') end
      end

      context 'should allow the provider to be overridden' do
        let :params do
          { package_name: 'dnsmasq', package_provider: 'foo' }
        end

        it do
          is_expected.to contain_package('dnsmasq').with_provider('foo')
        end
      end
    end

    describe 'dnsmasq::config' do
      let :params do
        {
          package_ensure: 'present',
          package_name: 'dnsmasq',
          package_manage: true,
        }
      end

      it do
        is_expected.to contain_concat('dnsmasq.conf').with(
          ensure_newline: true,
          warn: true,
          owner: 0,
          group: 0,
          mode: '0644',
        )
      end
      it do
        is_expected.to contain_concat__fragment('dnsmasq.conf_top').with(
          order: '00',
          target: 'dnsmasq.conf',
        )
      end

      context 'dnsmasq::config with enable_tftp' do
        let :params do
          { enable_tftp: true }
        end

        it do
          is_expected.to contain_concat__fragment('dnsmasq.conf_top').with_content(
            %r{\nenable-tftp\n},
          )
        end
      end
    end

    describe 'dnsmasq::service' do
      let :params do
        { service_name: 'dnsmasq' }
      end

      context 'with defaults' do
        it do
          is_expected.to contain_exec('dnsmasq --test').with(
            refreshonly: true,
          ).that_comes_before('Service[dnsmasq]')
        end
        it do
          is_expected.to contain_service('dnsmasq').with(
            ensure: 'running',
            enable: true,
            hasstatus: true,
          )
        end
      end

      context 'service_manage when false' do
        let :params do
          { service_name: 'dnsmasqd', service_manage: false }
        end

        it do is_expected.not_to contain_service('dnsmasqd') end
      end

      context 'service_ensure when overridden' do
        let :params do
          {
            service_name: 'dnsmasqd',
            service_enable: false,
            service_ensure: 'stopped',
          }
        end

        it do
          is_expected.to contain_service('dnsmasq').with(
            ensure: 'stopped',
            enable: false,
          )
        end
      end
    end
  end

  shared_context 'Darwin' do
    describe 'dnsmasq::install' do
      it do
        is_expected.to contain_package('dnsmasq').with(
          ensure: 'present',
          provider: 'macports',
        )
      end
    end

    describe 'dnsmasq::config' do
      it do
        is_expected.to contain_concat('dnsmasq.conf').with_path('/opt/local/etc/dnsmasq.conf')
      end
      it do
        is_expected.to contain_file('/opt/local/etc/dnsmasq.d').with(
          ensure: 'directory',
          owner: 0,
          group: 0,
          mode: '0755',
          purge: true,
          recurse: true,
          recurselimit: 1,
        )
      end
      it do
        is_expected.to contain_dnsmasq__config__conf_dir('/opt/local/etc/dnsmasq.d')
      end
    end

    describe 'dnsmasq::service' do
      it do
        is_expected.to contain_service('dnsmasq').with(
          name: 'org.macports.dnsmasq',
        )
      end
      it do
        is_expected.to contain_exec('dnsmasq --test').with(
          command: 'dnsmasq --conf-file=/opt/local/etc/dnsmasq.conf --test',
          path: ['/opt/local/bin', '/opt/local/sbin', '/bin', '/sbin', '/usr/bin', '/usr/sbin'],
        ).that_comes_before('Service[dnsmasq]')
      end
    end

    describe 'dnsmasq::firewall' do
      context 'manage IPv4' do
        let :params do
          { firewall_ipv4_manage: true }
        end

        it do is_expected.not_to compile end
        it do
          is_expected.to raise_error(
            Puppet::Error, %r{Darwin is unsupported by dnsmasq}
          )
        end
      end

      context 'manage IPv6' do
        let :params do
          { firewall_ipv6_manage: true }
        end

        it do is_expected.not_to compile end
        it do
          is_expected.to raise_error(
            Puppet::Error, %r{Darwin is unsupported by dnsmasq}
          )
        end
      end
    end
  end

  shared_context 'FreeBSD' do
    describe 'dnsmasq::install' do
      it do is_expected.to contain_package('dns/dnsmasq').with_ensure('present') end
    end

    describe 'dnsmasq::config' do
      it do
        is_expected.to contain_concat('dnsmasq.conf').with_path('/usr/local/etc/dnsmasq.conf')
      end
      it do
        is_expected.to contain_file('/usr/local/etc/dnsmasq.d').with(
          ensure: 'directory',
          owner: 0,
          group: 0,
          mode: '0755',
          purge: true,
          recurse: true,
          recurselimit: 1,
        )
      end
      it do
        is_expected.to contain_dnsmasq__config__conf_dir('/usr/local/etc/dnsmasq.d')
      end
    end

    describe 'dnsmasq::service' do
      it do
        is_expected.to contain_exec('dnsmasq --test').with(
          command: 'dnsmasq --conf-file=/usr/local/etc/dnsmasq.conf --test',
          path: ['/usr/local/bin', '/usr/local/sbin', '/bin', '/sbin', '/usr/bin', '/usr/sbin'],
        ).that_comes_before('Service[dnsmasq]')
      end
    end

    describe 'dnsmasq::firewall' do
      context 'manage IPv4' do
        let :params do
          { firewall_ipv4_manage: true }
        end

        it do is_expected.not_to compile end
        it do
          is_expected.to raise_error(
            Puppet::Error, %r{FreeBSD is unsupported by dnsmasq}
          )
        end
      end

      context 'manage IPv6' do
        let :params do
          { firewall_ipv6_manage: true }
        end

        it do is_expected.not_to compile end
        it do
          is_expected.to raise_error(
            Puppet::Error, %r{FreeBSD is unsupported by dnsmasq}
          )
        end
      end
    end
  end

  shared_context 'Linux' do
    describe 'dnsmasq::install' do
      it do is_expected.to contain_package('dnsmasq').with_ensure('present') end
    end

    describe 'dnsmasq::config' do
      it do
        is_expected.to contain_concat('dnsmasq.conf').with_path('/etc/dnsmasq.conf')
      end
      it do
        is_expected.to contain_file('/etc/dnsmasq.d').with(
          ensure: 'directory',
          owner: 0,
          group: 0,
          mode: '0755',
          purge: true,
          recurse: true,
          recurselimit: 1,
        )
      end
      it do
        is_expected.to contain_dnsmasq__config__conf_dir('/etc/dnsmasq.d')
      end

      context 'dnsmasq::config with enable_tftp' do
        let :params do
          {
            enable_tftp: true,
            firewall_ipv4_manage: true,
            firewall_ipv6_manage: true,
            tftp_port_range_start: 40_000,
            tftp_port_range_end: 40_999,
          }
        end

        it do is_expected.to contain_class('dnsmasq::firewall_tftp') end
        it do is_expected.to contain_firewall('099 dnsmasq IPv4 UDP TFTP').with_dport(69) end
        it do is_expected.to contain_firewall('099 dnsmasq IPv4 UDP TFTP Port Range').with_dport('40000-40999') end
        it do is_expected.to contain_firewall('099 dnsmasq IPv6 UDP TFTP').with_dport(69) end
        it do is_expected.to contain_firewall('099 dnsmasq IPv6 UDP TFTP Port Range').with_dport('40000-40999') end
      end
    end

    describe 'dnsmasq::service' do
      it do
        is_expected.to contain_exec('dnsmasq --test').with(
          command: 'dnsmasq --conf-file=/etc/dnsmasq.conf --test',
          path: ['/bin', '/sbin', '/usr/bin', '/usr/sbin'],
        ).that_comes_before('Service[dnsmasq]')
      end
    end

    describe 'dnsmasq::firewall' do
      context 'manage IPv4' do
        let :params do
          { firewall_ipv4_manage: true }
        end

        it do is_expected.to contain_class('dnsmasq::firewall_dns') end
        it do
          is_expected.to contain_firewall('099 dnsmasq IPv4 udp DNS').with(
            dport: 53,
            proto: 'udp',
            provider: nil,
          )
        end
        it do
          is_expected.to contain_firewall('099 dnsmasq IPv4 tcp DNS').with(
            dport: 53,
            proto: 'tcp',
            provider: nil,
          )
        end
      end

      context 'manage IPv6' do
        let :params do
          { firewall_ipv6_manage: true }
        end

        it do is_expected.to contain_class('dnsmasq::firewall_dns') end
        it do
          is_expected.to contain_firewall('099 dnsmasq IPv6 udp DNS').with(
            dport: 53,
            proto: 'udp',
            provider: 'ip6tables',
          )
        end
        it do
          is_expected.to contain_firewall('099 dnsmasq IPv6 tcp DNS').with(
            dport: 53,
            proto: 'tcp',
            provider: 'ip6tables',
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

      case facts[:kernel]
      when 'Darwin' then it_behaves_like 'Darwin'
      when 'FreeBSD' then it_behaves_like 'FreeBSD'
      when 'Linux' then it_behaves_like 'Linux'
      end
    end
  end
end
