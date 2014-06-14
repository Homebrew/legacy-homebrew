require 'formula'

class Bitlbee < Formula
  homepage 'http://www.bitlbee.org/'
  url 'http://get.bitlbee.org/src/bitlbee-3.2.1.tar.gz'
  sha1 '954471ab87206826c072f31b3def40a1be5a78f5'
  revision 2

  bottle do
    sha1 "87aaac8542c0e5fcfaa81a5d0464d48043cf0389" => :mavericks
    sha1 "7aa598b16ce35182e9c061dbc27a1a08e3462c6f" => :mountain_lion
    sha1 "af0cdf96d4a5e718f191ecdc7cda133e8849bff0" => :lion
  end

  option 'with-finch', "Use finch/libpurple for all communication with instant messaging networks"
  option 'with-libotr', "Build with otr (off the record) support"

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gnutls'
  depends_on 'libgcrypt'
  depends_on 'finch' => :optional
  depends_on 'libotr' => :optional

  if build.with? "libotr"
    # Head versions of bitlbee support otr4, but there is no release yet.
    patch do
      url "http://ftp.de.debian.org/debian/pool/main/b/bitlbee/bitlbee_3.2.1+otr4-1.diff.gz"
      sha1 "a05af5ec8912f85b876f90e75a78dc4f98917ead"
    end
  end

  def install
    args = ["--prefix=#{prefix}",
            "--debug=0",
            "--ssl=gnutls",
            "--pidfile=#{var}/bitlbee/run/bitlbee.pid",
            "--config=#{var}/bitlbee/lib/",
            "--ipsocket=#{var}/bitlbee/run/bitlbee.sock"]

    args << "--purple=1" if build.with? "finch"
    args << "--otr=1" if build.with? "libotr"

    system "./configure", *args

    # This build depends on make running first.
    system "make"
    system "make install"
    # Install the dev headers too
    system "make install-dev"
    # This build has an extra step.
    system "make install-etc"

    (var+"bitlbee/run").mkpath
    (var+"bitlbee/lib").mkpath
  end

  plist_options :manual => "bitlbee -D"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>OnDemand</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/bitlbee</string>
      </array>
      <key>ServiceDescription</key>
      <string>bitlbee irc-im proxy</string>
      <key>Sockets</key>
      <dict>
        <key>Listener</key>
        <dict>
          <key>SockFamily</key>
          <string>IPv4</string>
          <key>SockProtocol</key>
          <string>TCP</string>
          <key>SockServiceName</key>
          <string>6667</string>
          <key>SockType</key>
          <string>stream</string>
        </dict>
      </dict>
      <key>inetdCompatibility</key>
      <dict>
        <key>Wait</key>
        <false/>
      </dict>
    </dict>
    </plist>
    EOS
  end
end
