require 'formula'

class Icinga < Formula
  homepage 'https://www.icinga.org'
  url 'http://downloads.sourceforge.net/project/icinga/icinga/1.9.1/icinga-1.9.1.tar.gz'
  sha1 '353fb915120d7814da4a6a097fd586d3989b90f9'

  depends_on 'gd'
  depends_on 'nagios-plugins'
  depends_on :libpng

  def icinga_sbin; prefix+'cgi-bin'; end
  def icinga_etc; etc+'icinga'; end
  def icinga_var; var+'lib/icinga'; end
  def htdocs; share+'icinga/htdocs'; end
  def user; `id -un`.chomp; end
  def group; `id -gn`.chomp; end

  def install
    system "./configure", "--disable-idoutils",
                          "--prefix=#{prefix}",
                          "--sbindir=#{icinga_sbin}",
                          "--sysconfdir=#{icinga_etc}",
                          "--localstatedir=#{icinga_var}",
                          "--datadir=#{htdocs}",
                          "--libexecdir=#{HOMEBREW_PREFIX}/sbin", # Plugin dir
                          "--with-cgiurl=/icinga/cgi-bin",
                          "--with-htmurl=/icinga",
                          "--with-icinga-user=#{user}",
                          "--with-icinga-group=#{group}",
                          "--with-command-user=#{user}",
                          "--with-command-group=_www",
                          "--with-httpd-conf=#{share}"
    system "make all"
    system "make install"
    system "make fullinstall"
    system "make install-config"
    mkdir HOMEBREW_PREFIX+'var/lib/icinga/rw' unless File.exists? HOMEBREW_PREFIX+'var/lib/icinga/rw'
  end

  plist_options :startup => true, :manual => "icinga #{HOMEBREW_PREFIX}/etc/icinga/icinga.cfg"

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
            <string>#{opt_prefix}/bin/icinga</string>
            <string>#{icinga_etc}/icinga.cfg</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>StandardErrorPath</key>
        <string>/dev/null</string>
        <key>StandardOutPath</key>
        <string>/dev/null</string>
    </dict>
    </plist>
    EOS
    end

    def caveats; <<-EOS.undent
    First we need to create a command dir using superhuman powers:

    mkdir -p #{icinga_var}/rw
    sudo chgrp _www #{icinga_var}/rw
    sudo chmod 2775 #{icinga_var}/rw

    Then install the icinga web frontend into Apple's build-in Apache:

    1) Turn on Personal Web Sharing.

    2) Load the php module by changing /etc/apache2/httpd.conf:

    -#LoadModule php5_module libexec/apache2/libphp5.so
    +LoadModule php5_module libexec/apache2/libphp5.so

    3) Symlink the sample config and create your web account:

    sudo ln -sf #{share}/icinga.conf /etc/apache2/other/
    htpasswd -cs #{icinga_etc}/htpasswd.users icingaadmin

    4) Reload the configuration. Restart Apache Web Server

    sudo apachectl -k graceful

    Log in with your web account (and don't forget to RTFM :-)

    open http://localhost/icinga

    EOS
  end
end
