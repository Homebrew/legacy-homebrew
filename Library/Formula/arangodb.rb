require 'formula'

class Arangodb < Formula
  homepage 'http://www.arangodb.org/'
  url 'https://github.com/triAGENS/ArangoDB/archive/v1.2.3.tar.gz'
  sha1 '14e77ce4c8fa0b55b371dee06d8ccf0edef5ba68'

  head "https://github.com/triAGENS/ArangoDB.git", :branch => 'unstable'

  devel do
    version "1.3.0-alpha2"
    url 'https://github.com/triAGENS/ArangoDB/archive/v1.3.0-alpha2.tar.gz'
    sha1 '058c0edcba0d2e79c95b41ca2d717296d77dd9be'
  end

  depends_on 'icu4c'
  depends_on 'libev'
  depends_on 'v8'

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --disable-relative
      --disable-all-in-one-icu
      --disable-all-in-one-libev
      --disable-all-in-one-v8
      --enable-mruby
      --datadir=#{share}
      --localstatedir=#{var}
    ]

    if build.devel?
      args << "--program-suffix=-#{version}"
    end

    if build.head?
      args << "--program-suffix=-unstable"
    end

    system "./configure", *args
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
      </dict>
    </plist>
    EOS
  end
end
