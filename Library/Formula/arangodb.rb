require 'formula'

class Arangodb < Formula
  homepage 'http://www.arangodb.org/'
<<<<<<< HEAD
<<<<<<< HEAD
  url "https://github.com/triAGENS/ArangoDB/zipball/v1.0.beta1"
  sha1 '36b280accbe049c509814f1ab8a28837fb0239c2'
=======
  url 'https://github.com/triAGENS/ArangoDB/zipball/v1.0.0'
  sha1 '2a3b58967f41116cb9422e3e159ea526081310c7'
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
=======
  url 'https://github.com/triAGENS/ArangoDB/zipball/v1.1.2'
  sha1 'e5a723475f5d1083cb3c377139222aaff898fe94'
>>>>>>> 35b0414670cc73c4050f911c89fc1602fa6a1d40

  head "https://github.com/triAGENS/ArangoDB.git"

  devel do
    url 'https://github.com/triAGENS/ArangoDB/zipball/v1.2.beta3'
    sha1 '5eb9c5753579a04893f0afa3f5e6e90ddd709ebc'
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
      http://www.arangodb.org/manuals/1.1/Upgrading.html

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
