require 'formula'

class Bitlbee < Formula
  homepage 'http://www.bitlbee.org/'
  url 'http://get.bitlbee.org/src/bitlbee-3.2.2.tar.gz'
  sha1 '7e3cfe2b6bf4e8e603c74e7587307a6f5d267e9c'

  bottle do
    sha1 "4a639d88aa819d23d6020a36602097474f66357d" => :mavericks
    sha1 "5312823fead39bba80b712bcedca4f9a7fc9211d" => :mountain_lion
    sha1 "c21d19af516d959eb2a0b4b5ff534a66678d419d" => :lion
  end

  option 'with-finch', "Use finch/libpurple for all communication with instant messaging networks"
  option 'with-libotr', "Build with otr (off the record) support"

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'gnutls'
  depends_on 'libgcrypt'
  depends_on 'finch' => :optional
  depends_on 'libotr' => :optional

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
