require 'formula'

class Nagios < Formula
  homepage 'http://www.nagios.org/'
  url 'http://downloads.sourceforge.net/project/nagios/nagios-3.x/nagios-3.4.1/nagios-3.4.1.tar.gz'
  md5 '2fa8acfb2a92b1bf8d173a855832de1f'

  depends_on 'gd'
  depends_on 'nagios-plugins'
  depends_on :x11 # Required to compile some CGI's against the build-in libpng.

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
    (share+plist_path).write startup_plist
  end

  def startup_plist
    <<-EOS.undent
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
                    <string>#{HOMEBREW_PREFIX}/bin/nagios</string>
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

  def caveats
    <<-EOS.undent
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

    If you want to run nagios automatically at startup:

      sudo cp #{share}/#{plist_path.basename} /Library/LaunchDaemons/
      sudo launchctl load -w /Library/LaunchDaemons/#{plist_path.basename}

    ...or simply run it on demand:

      nagios #{nagios_etc}/nagios.cfg

    Now log in with your web account (and don't forget to RTFM :-)

      open http://localhost/nagios

    EOS
  end
end
