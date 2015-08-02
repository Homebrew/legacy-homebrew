class Lldpd < Formula
  desc "Implementation library for LLDP"
  homepage "https://vincentbernat.github.io/lldpd/"
  url "http://media.luffy.cx/files/lldpd/lldpd-0.7.15.tar.gz"
  sha256 "c891d6d4480a6a890561ac43d8cc923bd027deb82a3999d65f37d96ca368c246"

  bottle do
    sha256 "168901752a250081bcfb46a44ec627fc5694716a1a5c76ad85685777f50d3adb" => :yosemite
    sha256 "712cc05430e9af6156f6e9148bbf33a082bcbd2bae2b74dc118384e7d65ca9dd" => :mavericks
    sha256 "08e223c0809438da4762a568518b3b86a28fe3d30dc245fb9318c75514b923bc" => :mountain_lion
  end

  option "with-snmp", "Build SNMP subagent support"
  option "with-json", "Build JSON support for lldpcli"

  depends_on "pkg-config" => :build
  depends_on "readline"
  depends_on "libevent"
  depends_on "net-snmp" if build.with? "snmp"
  depends_on "jansson"  if build.with? "json"

  def install
    readline = Formula["readline"]
    args = ["--prefix=#{prefix}",
            "--with-xml",
            "--with-readline",
            "--with-privsep-chroot=/var/empty",
            "--with-privsep-user=nobody",
            "--with-privsep-group=nogroup",
            "--with-launchddaemonsdir=no",
            "CPPFLAGS=-I#{readline.include} -DRONLY=1",
            "LDFLAGS=-L#{readline.lib}"]
    args << "--with-snmp" if build.with? "snmp"
    args << "--with-json" if build.with? "json"

    system "./configure", *args
    system "make"
    system "make install"
  end

  plist_options :startup => true

  def plist
    additional_args = ""
    if build.with? "snmp"
      additional_args += "<string>-x</string>"
    end
    <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_sbin}/lldpd</string>
        #{additional_args}
      </array>
      <key>RunAtLoad</key><true/>
      <key>KeepAlive</key><true/>
    </dict>
    </plist>
    EOS
  end
end
