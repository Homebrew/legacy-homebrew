require 'formula'

class Nagios < Formula
  homepage 'http://www.nagios.org/'
  url 'http://sourceforge.net/projects/nagios/files/nagios-3.x/nagios-3.4.4/nagios-3.4.4.tar.gz'
  sha1 '19aaa4eda92a2837fe29ebcbe85140aef50e90cd'

  depends_on 'gd'
  depends_on 'nagios-plugins'
  depends_on :libpng

  def nagios_sbin;  prefix+'cgi-bin';       end
  def nagios_etc;   etc+'nagios';           end
  def nagios_var;   var+'lib/nagios';       end
  def htdocs;       share+'nagios/htdocs';  end
  def user;         `id -un`.chomp;         end
  def group;        `id -gn`.chomp;         end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--sbindir=#{nagios_sbin}",
                          "--sysconfdir=#{nagios_etc}",
                          "--localstatedir=#{nagios_var}",
                          "--datadir=#{htdocs}",
                          "--libexecdir=#{HOMEBREW_PREFIX}/sbin", # Plugin dir
                          "--with-cgiurl=/nagios/cgi-bin",
                          "--with-htmurl=/nagios",
                          "--with-nagios-user=#{user}",
                          "--with-nagios-group=#{group}",
                          "--with-command-user=#{user}",
                          "--with-command-group=_www",
                          "--with-httpd-conf=#{share}"
    system "make all"
    system "make install"

    # Install config
    system "make install-config"
    system "make install-webconf"
    mkdir HOMEBREW_PREFIX+'var/lib/nagios/rw' unless File.exists? HOMEBREW_PREFIX+'var/lib/nagios/rw'
  end

  plist_options :startup => true, :manual => "nagios #{HOMEBREW_PREFIX}/etc/nagios/nagios.cfg"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
            <key>KeepAlive</key>
            <true/>
            <key>Label</key>
            <string>#{plist_name}</string>
            <key>ProgramArguments</key>
            <array>
                    <string>#{opt_prefix}/bin/nagios</string>
                    <string>#{nagios_etc}/nagios.cfg</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
            <key>StandardErrorPath</key>
            <string>/dev/null</string>
            <key>StandardOutPath</key>
            <string>/dev/null</string>
            <key>UserName</key>
            <string>#{user}</string>
    </dict>
    </plist>
    EOS
  end

  def caveats; <<-EOS.undent
    First we need to create a command dir using superhuman powers:

      mkdir -p #{nagios_var}/rw
      sudo chgrp _www #{nagios_var}/rw
      sudo chmod 2775 #{nagios_var}/rw

    Then install the Nagios web frontend into Apple's build-in Apache:

      1) Turn on Personal Web Sharing.

      2) Load the php module by patching /etc/apache2/httpd.conf:

        -#LoadModule php5_module        libexec/apache2/libphp5.so
        +LoadModule php5_module        libexec/apache2/libphp5.so

      3) Symlink the sample config and create your web account:

        sudo ln -sf #{share}/nagios.conf /etc/apache2/other/
        htpasswd -cs #{nagios_etc}/htpasswd.users nagiosadmin
        sudo apachectl restart

    Log in with your web account (and don't forget to RTFM :-)

      open http://localhost/nagios

    EOS
  end
end
