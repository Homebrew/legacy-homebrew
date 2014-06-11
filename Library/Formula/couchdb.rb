require 'formula'

class Couchdb < Formula
  homepage "http://couchdb.apache.org/"
  url 'http://www.apache.org/dyn/closer.cgi?path=/couchdb/source/1.6.0/apache-couchdb-1.6.0.tar.gz'
  sha1 '62f99077c201ad632c1cd144fcaf6f10fa5949ed'

  bottle do
    sha1 "98757863115f93f5548103b02f6b9d4bcef9777a" => :mavericks
    sha1 "33b440eb0e1fc0e0c1ba001d7167e61dd0eaa5b9" => :mountain_lion
    sha1 "b3d27eb54507f2d6cb822f2b18da86c0bf9d860f" => :lion
  end

  head do
    url 'http://git-wip-us.apache.org/repos/asf/couchdb.git'

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "autoconf-archive" => :build
    depends_on "pkg-config" => :build
    depends_on "help2man" => :build
  end

  depends_on 'spidermonkey'
  depends_on 'icu4c'
  depends_on 'erlang'
  depends_on 'curl' if MacOS.version <= :leopard

  def install
    # CouchDB >=1.3.0 supports vendor names and versioning
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

    # Use our plist instead to avoid faffing with a new system user.
    (prefix+"Library/LaunchDaemons/org.apache.couchdb.plist").delete
    (lib+'couchdb/bin/couchjs').chmod 0755
    (var+'lib/couchdb').mkpath
    (var+'log/couchdb').mkpath
  end

  plist_options :manual => "couchdb"

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
        <string>#{opt_bin}/couchdb</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    # ensure couchdb embedded spidermonkey vm works
    system "#{bin}/couchjs", "-h"
  end

  def caveats; <<-EOS.undent
    To test CouchDB run:
        curl http://127.0.0.1:5984/

    The reply should look like:
        {"couchdb":"Welcome","uuid":"....","version":"#{version}","vendor":{"version":"#{version}-1","name":"Homebrew"}}
    EOS
  end
end
