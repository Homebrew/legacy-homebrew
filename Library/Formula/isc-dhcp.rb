require 'formula'

class IscDhcp < Formula
  homepage 'http://www.isc.org/software/dhcp'
  url 'http://ftp.isc.org/isc/dhcp/4.2.5/dhcp-4.2.5.tar.gz'
  sha1 'd029505509aee83ea28972d5d1c95dc4b5db99f1'

  def install
    # use one dir under var for all runtime state.
    dhcpd_dir = var+'dhcpd'

    # Change the locations of various files to match Homebrew
    # we pass these in through CFLAGS since some cannot be changed
    # via configure args.
    path_opts = {
      '_PATH_DHCPD_CONF'    => etc+'dhcpd.conf',
      '_PATH_DHCLIENT_CONF' => etc+'dhclient.conf',
      '_PATH_DHCPD_DB'      => dhcpd_dir+'dhcpd.leases',
      '_PATH_DHCPD6_DB'     => dhcpd_dir+'dhcpd6.leases',
      '_PATH_DHCLIENT_DB'   => dhcpd_dir+'dhclient.leases',
      '_PATH_DHCLIENT6_DB'  => dhcpd_dir+'dhclient6.leases',
      '_PATH_DHCPD_PID'     => dhcpd_dir+'dhcpd.pid',
      '_PATH_DHCPD6_PID'    => dhcpd_dir+'dhcpd6.pid',
      '_PATH_DHCLIENT_PID'  => dhcpd_dir+'dhclient.pid',
      '_PATH_DHCLIENT6_PID' => dhcpd_dir+'dhclient6.pid',
      '_PATH_DHCRELAY_PID'  => dhcpd_dir+'dhcrelay.pid',
      '_PATH_DHCRELAY6_PID' => dhcpd_dir+'dhcrelay6.pid',
    }

    path_opts.each do |symbol,path|
      ENV.append 'CFLAGS', "-D#{symbol}='\"#{path}\"'"
    end

    # See discussion at: https://gist.github.com/1157223
    if MacOS.version >= :lion
      ENV.append 'CFLAGS', "-D__APPLE_USE_RFC_3542"
    end

    system './configure', "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{dhcpd_dir}"

    # the 'bind' subdirectory doesn't like overly parallel builds
    # so build it sequentially. deparallelizing the whole build
    # can be slow.
    previous_makeflags = ENV['MAKEFLAGS']
    ENV.deparallelize
    system 'make -C bind'
    ENV['MAKEFLAGS'] = previous_makeflags

    # build everything else
    inreplace 'Makefile', 'SUBDIRS = bind', 'SUBDIRS = '
    system 'make'
    system 'make install'

    # rename all the installed sample etc/* files so they don't clobber
    # any existing config files at symlink time.
    Dir.open(prefix+'etc') do |dir|
      dir.each do |f|
        file = "#{dir.path}/#{f}"
        File.rename(file, "#{file}.sample") if File.stat(file).file?
      end
    end

    # create the state dir and lease files else dhcpd will not start up.
    dhcpd_dir.mkpath
    %w(dhcpd dhcpd6 dhclient dhclient6).each do |f|
      file = "#{dhcpd_dir}/#{f}.leases"
      File.new(file, File::CREAT|File::RDONLY).close
    end

    # dhcpv6 plists
    (prefix+'homebrew.mxcl.dhcpd6.plist').write plist_dhcpd6
    (prefix+'homebrew.mxcl.dhcpd6.plist').chmod 0644
  end

  def caveats; <<-EOS.undent
    This install of dhcpd expects config files to be in #{etc}.
    All state files (leases and pids) are stored in #{var}/dhcpd.

    Dhcpd needs to run as root since it listens on privileged ports.

    There are two plists because a single dhcpd process may do either
    DHCPv4 or DHCPv6 but not both. Use one or both as needed.

    Note that you must create the appropriate config files before starting
    the services or dhcpd will refuse to run.
      DHCPv4: #{etc}/dhcpd.conf
      DHCPv6: #{etc}/dhcpd6.conf

    Sample config files may be found in #{etc}.
    EOS
  end

  plist_options :startup => true

  def plist
    <<-EOS.undent
    <?xml version='1.0' encoding='UTF-8'?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
                    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version='1.0'>
    <dict>
    <key>Label</key><string>#{plist_name}</string>
    <key>ProgramArguments</key>
      <array>
        <string>#{opt_prefix}/sbin/dhcpd</string>
        <string>-f</string>
      </array>
    <key>Disabled</key><false/>
    <key>KeepAlive</key><true/>
    <key>RunAtLoad</key><true/>
    <key>LowPriorityIO</key><true/>
    </dict>
    </plist>
    EOS
  end

  def plist_dhcpd6
    <<-EOS.undent
    <?xml version='1.0' encoding='UTF-8'?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN"
                    "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version='1.0'>
    <dict>
    <key>Label</key><string>#{plist_name}</string>
    <key>ProgramArguments</key>
      <array>
        <string>#{opt_prefix}/sbin/dhcpd</string>
        <string>-f</string>
        <string>-6</string>
        <string>-cf</string>
        <string>#{etc}/dhcpd6.conf</string>
      </array>
    <key>Disabled</key><false/>
    <key>KeepAlive</key><true/>
    <key>RunAtLoad</key><true/>
    <key>LowPriorityIO</key><true/>
    </dict>
    </plist>
    EOS
  end
end
