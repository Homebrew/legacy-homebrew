require 'formula'

class Arangodb < Formula
  homepage 'http://www.arangodb.org/'
  url 'https://github.com/triAGENS/ArangoDB/archive/v1.2.2.tar.gz'
  sha1 '1b4390e4ad100c93900651a522a21395d077b0e6'

  head "https://github.com/triAGENS/ArangoDB.git"

  devel do
    url 'https://github.com/triAGENS/ArangoDB/archive/v1.3.alpha1.tar.gz'
    sha1 '51173707f29bc7c239c06c5043776637b325766b'
  end

  depends_on 'icu4c'
  depends_on 'libev'
  depends_on 'v8'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-relative",
                          "--disable-all-in-one-icu",
                          "--disable-all-in-one-libev",
                          "--disable-all-in-one-v8",
                          "--enable-mruby",
                          "--datadir=#{share}",
                          "--localstatedir=#{var}"

    system "make install"

    (var+'arangodb').mkpath
    (var+'log/arangodb').mkpath
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/arangodb/sbin/arangod"

  def caveats; <<-EOS.undent
    ArangoDB (http://www.arangodb.org)
      A universal open-source database with a flexible data model for documents,
      graphs, and key-values.

    First Steps with ArangoDB:
      http:/www.arangodb.org/quickstart

    Upgrading ArangoDB:
      http://www.arangodb.org/manuals/1.2/Upgrading.html

    Configuration file:
      /usr/local/etc/arangodb/arangod.conf

    Start ArangoDB server:
      unix> /usr/local/sbin/arangod

    Start ArangoDB shell client (use empty password):
      unix> /usr/local/bin/arangosh

    EOS
  end

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
          <string>#{opt_prefix}/sbin/arangod</string>
          <string>-c</string>
          <string>#{etc}/arangodb/arangod.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>UserName</key>
        <string>#{`whoami`.chomp}</string>
      </dict>
    </plist>
    EOS
  end
end
