class Lldpd < Formula
  desc "Implementation library for LLDP"
  homepage "https://vincentbernat.github.io/lldpd/"
  url "http://media.luffy.cx/files/lldpd/lldpd-0.7.16.tar.gz"
  sha256 "a0b85a5e685b8e7dad08b6f20ea79d8bec47d8dbf39daef419bd20ad7f37d63f"

  bottle do
    sha256 "437aee53ffb9e71b91c2f53316fa0df319f2927b29e0c5cc3b3ee7b3141ae7c4" => :yosemite
    sha256 "8425d6857f0d9161f61d3c31e55d9c7c761c4a72bb37da8d94fd6ee518fda865" => :mavericks
    sha256 "b77527b4056776a1218ce5f4e97ee611a748112912b5c50a989853eabd4410b9" => :mountain_lion
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
            "--sysconfdir=#{etc}",
            "--localstatedir=#{var}",
            "--with-xml",
            "--with-readline",
            "--with-privsep-chroot=/var/empty",
            "--with-privsep-user=nobody",
            "--with-privsep-group=nogroup",
            "--with-launchddaemonsdir=no",
            "CPPFLAGS=-I#{readline.include} -DRONLY=1",
            "LDFLAGS=-L#{readline.lib}"]
    args << (build.with?("snmp") ? "--with-snmp" : "--without-snmp")
    args << (build.with?("json") ? "--with-json" : "--without-json")

    system "./configure", *args
    system "make"
    system "make", "install"
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
