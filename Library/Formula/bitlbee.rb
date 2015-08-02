class Bitlbee < Formula
  desc "IRC to other chat networks gateway"
  homepage "http://www.bitlbee.org/"
  url "http://get.bitlbee.org/src/bitlbee-3.4.tar.gz"
  sha256 "cebad646bbfd17c80923743244039fd970e3ca27e8c1b7cf872622e773239d5e"

  head "https://github.com/bitlbee/bitlbee.git"

  bottle do
    revision 1
    sha256 "7d334c77a568e3fe8ce4cd4efa2d0c8e3d462c85375904324259079a60bee4e8" => :yosemite
    sha256 "816c3bae6837ee5d2fb32122885a08667dcfcac57c78a95f21fba885de88e239" => :mavericks
    sha256 "da53bd351717e41479d335d21e580461d1c372913b352fb58572ef8c07232c58" => :mountain_lion
  end

  option "with-pidgin", "Use finch/libpurple for all communication with instant messaging networks"
  option "with-libotr", "Build with otr (off the record) support"

  deprecated_option "with-finch" => "with-pidgin"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "gnutls"
  depends_on "libgcrypt"
  depends_on "pidgin" => :optional
  depends_on "libotr" => :optional

  def install
    args = ["--prefix=#{prefix}",
            "--debug=0",
            "--ssl=gnutls",
            "--pidfile=#{var}/bitlbee/run/bitlbee.pid",
            "--config=#{var}/bitlbee/lib/",
            "--ipsocket=#{var}/bitlbee/run/bitlbee.sock"]

    args << "--purple=1" if build.with? "pidgin"
    args << "--otr=1" if build.with? "libotr"

    system "./configure", *args

    # This build depends on make running first.
    system "make"
    system "make", "install"
    # Install the dev headers too
    system "make", "install-dev"
    # This build has an extra step.
    system "make", "install-etc"

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
          <key>SockNodeName</key>
          <string>127.0.0.1</string>
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

  test do
    shell_output("#{sbin}/bitlbee -V", 1)
  end
end
