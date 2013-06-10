require 'formula'

class Couchdb < Formula
  homepage "http://couchdb.apache.org/"
  url 'http://www.apache.org/dyn/closer.cgi?path=/couchdb/source/1.3.0/apache-couchdb-1.3.0.tar.gz'
  sha1 '1085297fcabb020f407283aba1f74302c9923fa0'

  head 'http://git-wip-us.apache.org/repos/asf/couchdb.git'

  if build.devel? or build.head?
    depends_on :automake => :build
    depends_on :libtool => :build
    # CouchDB >= 1.3.0 requires autoconf 2.63 or higher
    depends_on 'autoconf' => :build
    depends_on 'autoconf-archive' => :build
    depends_on 'pkg-config' => :build
    depends_on 'help2man' => :build
  end
  depends_on 'spidermonkey'
  depends_on 'icu4c'
  depends_on 'erlang'
  depends_on 'curl' if MacOS.version == :leopard

  def install
    # couchdb 1.3.0 supports vendor names and versioning
    # in the welcome message
    inreplace 'etc/couchdb/default.ini.tpl.in' do |s|
      s.gsub! '%package_author_name%', 'Homebrew'
      s.gsub! '%version%', '%version%-1'
    end

    if build.devel? or build.head?
      # workaround for the auto-generation of THANKS file which assumes
      # a developer build environment incl access to git sha
      touch "THANKS"
      system "./bootstrap"
    end

    system "./configure", "--prefix=#{prefix}",
                          "--localstatedir=#{var}",
                          "--sysconfdir=#{etc}",
                          "--disable-init",
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
    # ensure couchdb embedded spidermonkey vm works
    system "#{bin}/couchjs", "-h"
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

    Or start manually as the current user with `couchdb`.

    To test CouchDB, start `couchdb` in a terminal and then:
      curl http://127.0.0.1:5984/

    The reply should look like:
      {"couchdb":"Welcome","uuid":"....","version":"1.3.0",
          "vendor":{"version":"1.3.0-1","name":"Homebrew"}}
    EOS
  end
end
