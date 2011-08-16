require 'formula'

class Couchdb < Formula
  url 'http://www.apache.org/dyn/closer.cgi?path=couchdb/1.1.0/apache-couchdb-1.1.0.tar.gz'
  homepage "http://couchdb.apache.org/"
  md5 '907b763d3a14b6649bf0371ffa75a36b'

  head 'http://svn.apache.org/repos/asf/couchdb/trunk'

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

  def test
    puts <<-EOS.undent
      To test CouchDB, start `couchdb` in a terminal and then:
        curl http://127.0.0.1:5984/

      The reply should look like:
        {"couchdb":"Welcome","version":"1.1.0"}
    EOS
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
