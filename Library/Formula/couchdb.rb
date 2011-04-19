require 'formula'

class Couchdb < Formula
  url 'https://github.com/apache/couchdb/tarball/1.0.2'
  homepage "http://couchdb.apache.org/"
  md5 'cc1cc891ac47dd795b0b9aa2c5375923'

  depends_on 'spidermonkey'
  depends_on 'icu4c'
  depends_on 'erlang'
  depends_on 'curl' if MacOS.leopard?

  def install
    system "./bootstrap" if File.exists? "bootstrap"
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--with-erlang=#{HOMEBREW_PREFIX}/lib/erlang/usr/include",
                          "--with-js-include=#{HOMEBREW_PREFIX}/include",
                          "--with-js-lib=#{HOMEBREW_PREFIX}/lib"
    system "make"
    system "make install"

    (lib+'couchdb/bin/couchjs').chmod 0755
    (var+'lib/couchdb').mkpath
    (var+'log/couchdb').mkpath
  end

  def caveats; <<-EOS.undent
    If this is your first install, automatically load on login with:
        mkdir -p ~/Library/LaunchAgents
        cp #{prefix}/Library/LaunchDaemons/org.apache.couchdb.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.apache.couchdb.plist

    If this is an upgrade and you already have the org.apache.couchdb.plist loaded:
        launchctl unload -w ~/Library/LaunchAgents/org.apache.couchdb.plist
        cp #{prefix}/Library/LaunchDaemons/org.apache.couchdb.plist ~/Library/LaunchAgents/
        launchctl load -w ~/Library/LaunchAgents/org.apache.couchdb.plist

    Or start manually with:
        couchdb
    EOS
  end
end
