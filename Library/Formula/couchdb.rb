require 'formula'

class GeoCouch < Formula
  url 'https://github.com/couchbase/geocouch/tarball/d9c32ae6a53ed5cc5f76792cc7bb0ab4800b8da4', :using => :curl
  md5 'a9ae36150266b56916c737dd6f06e7fc'
  version '2012-01-06'
end

class Couchdb < Formula
  homepage "http://couchdb.apache.org/"
  url 'http://www.apache.org/dyn/closer.cgi?path=couchdb/releases/1.2.0/apache-couchdb-1.2.0.tar.gz'
  md5 'a5cbbcaac288831b3d8a08b725657f10'

  head 'http://git-wip-us.apache.org/repos/asf/couchdb.git'

  depends_on 'help2man' => :build
  depends_on 'spidermonkey'
  depends_on 'icu4c'
  depends_on 'erlang'
  depends_on 'curl' if MacOS.leopard?

  def options
    [
      [ '--with-geocouch', 'Include geocouch for spatial queries' ]
    ]
  end

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

    if ARGV.include? '--with-geocouch'
      couch_src = Dir.pwd
      couch_share = share
      GeoCouch.new.brew do
        ENV['COUCH_SRC'] = couch_src + '/src/couchdb'
        system "make"
        tests = Dir['share/www/script/test/*.js']
        (couch_share + 'couchdb/www/script/test/').install tests
        (etc + 'couchdb/local.d').install Dir['etc/couchdb/local.d/geocouch.ini']
        tests = tests.map { |a| a.gsub(/^.*\/(.*)$/, 'loadTest("\1");') }
        inreplace (couch_share + 'couchdb/www/script/couch_tests.js'), /\Z/m, tests.join("\n")

        (couch_share + 'couchdb/geocouch').mkpath
        (couch_share + 'couchdb/geocouch').install Dir['build']

        puts <<-EOS.undent
          You choose to install geocouch with couchdb. To ensure couchdb still starts
          please do one of the following actions:

          1) For automatic load on login:
             Add the following to ~/Library/LaunchAgents/org.apache.couchdb.plist in
             the <dict> under EnvironmentVariables:
             <key>ERL_FLAGS</key>
             <string>-pa /usr/local/share/couchdb/geocouch/build</string>

          2) For manual start:
             Add the following line to your ~/.bashrc
             export ERL_FLAGS="-pa /usr/local/share/couchdb/geocouch/build"

        EOS
      end
    end
  end

  def test
    puts <<-EOS.undent
      To test CouchDB, start `couchdb` in a terminal and then:
        curl http://127.0.0.1:5984/

      The reply should look like:
        {"couchdb":"Welcome","version":"1.2.0"}
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
    EOS
  end
end
