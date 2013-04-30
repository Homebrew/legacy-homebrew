require 'formula'

class Couchdb < Formula
  homepage "http://couchdb.apache.org/"
  url 'http://www.apache.org/dyn/closer.cgi?path=/couchdb/binary/mac/1.3.0/Apache-CouchDB.zip'
  sha1 'e5c3571435155728bcb575288a8309c67d74718a'

  head 'http://git-wip-us.apache.org/repos/asf/couchdb.git'

  depends_on 'help2man' => :build
  depends_on 'spidermonkey'
  depends_on 'icu4c'
  depends_on 'erlang'
  depends_on 'curl' if MacOS.version == :leopard

  def install
    system "./bootstrap" if File.exists? "bootstrap"
    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--with-erlang=#{HOMEBREW_PREFIX}/lib/erlang/usr/include",
                          "--with-js-include=#{HOMEBREW_PREFIX}/include/js",
                          "--with-js-lib=#{HOMEBREW_PREFIX}/lib"
    system "make"
    system "make install"

    (prefix+"Library/LaunchDaemons/org.apache.couchdb.plist").chmod 0644
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

    Alternatively, automatically run on startup as a daemon with:
        sudo launchctl list org.apache.couchdb \>/dev/null 2\>\&1 \&\& \\
          sudo launchctl unload -w /Library/LaunchDaemons/org.apache.couchdb.plist
        sudo cp #{prefix}/Library/LaunchDaemons/org.apache.couchdb.plist /Library/LaunchDaemons/
        sudo launchctl load -w /Library/LaunchDaemons/org.apache.couchdb.plist

    Or start manually as the current user with:
        couchdb
    EOS
  end
end
