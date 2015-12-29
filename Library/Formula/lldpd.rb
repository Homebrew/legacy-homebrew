class Lldpd < Formula
  desc "Implementation library for LLDP"
  homepage "https://vincentbernat.github.io/lldpd/"
  url "http://media.luffy.cx/files/lldpd/lldpd-0.7.19.tar.gz"
  sha256 "aac11cb1fdc037709517372c70c9bf89c752ab8e5eaab9ce140b84ed5a0507c8"

  bottle do
    sha256 "4e38f8e9e1861ecc1684152c1a558056920b1bacf494bf5f44d76f92c5764f36" => :el_capitan
    sha256 "c2f3532c713ee780011dde0208da4bf083397d9972ae5ad5cc85dd207c6ebe9e" => :yosemite
    sha256 "0852cc21ef55dde81b00c16bdff95d51044f374877b56eb7f68cb7e9f40678f7" => :mavericks
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
    args = [
      "--prefix=#{prefix}",
      "--sysconfdir=#{etc}",
      "--localstatedir=#{var}",
      "--with-xml",
      "--with-readline",
      "--with-privsep-chroot=/var/empty",
      "--with-privsep-user=nobody",
      "--with-privsep-group=nogroup",
      "--with-launchddaemonsdir=no",
      "CPPFLAGS=-I#{readline.include} -DRONLY=1",
      "LDFLAGS=-L#{readline.lib}",
    ]
    args << (build.with?("snmp") ? "--with-snmp" : "--without-snmp")
    args << (build.with?("json") ? "--with-json" : "--without-json")

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  def postinstall
    (var/"run").mkpath
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
