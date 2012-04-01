require 'formula'

class Couchdb < Formula
  homepage "http://couchdb.apache.org/"
  url 'http://www.apache.org/dyn/closer.cgi?path=couchdb/1.1.1/apache-couchdb-1.1.1.tar.gz'
  md5 'cd126219b9cb69a4c521abd6960807a6'

  devel do
   url 'http://git-wip-us.apache.org/repos/asf/couchdb.git', :using => :git, :tag => '1.2.x'
   version '1.2.x'
  end

  head 'http://git-wip-us.apache.org/repos/asf/couchdb.git', :using => :git

  depends_on 'help2man' => :build
  depends_on 'pkg-config'
  depends_on 'nspr'
  depends_on 'spidermonkey'
  depends_on 'icu4c'
  depends_on 'openssl'
  depends_on 'erlang'
  depends_on 'curl' if MacOS.leopard?

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

  def test
    puts <<-EOS.undent
      To test CouchDB, start `couchdb` in a terminal and then:
        curl http://127.0.0.1:5984/

      The reply should look like:
        {"couchdb":"Welcome","version":"1.1.1"}
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

    Alternatively, automatically run on startup as a daemon with:
        sudo launchctl list org.apache.couchdb \>/dev/null 2\>\&1 \&\& \\
          sudo launchctl unload -w /Library/LaunchDaemons/org.apache.couchdb.plist
        sudo cp #{prefix}/Library/LaunchDaemons/org.apache.couchdb.plist /Library/LaunchDaemons/
        sudo launchctl load -w /Library/LaunchDaemons/org.apache.couchdb.plist

    Or start manually as the current user with:
        couchdb
    
    If you are getting bus errors or segmentation faults, ensure
    that you have installed keg-only OpenSSL prior to brewing Erlang.
    You can check if Erlang is using otool:
    
        otool -l `mdfind -name crypto.so | grep Cellar` | grep openssl
    
    Output should be similar to:
    
       name /usr/local/Cellar/openssl/1.0.1/lib/libcrypto.1.0.0.dylib (offset 24)
       name /usr/local/Cellar/openssl/1.0.1/lib/libssl.1.0.0.dylib (offset 24)
    EOS
  end
end
