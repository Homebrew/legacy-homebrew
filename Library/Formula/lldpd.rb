require 'formula'

class Lldpd < Formula
  homepage 'http://vincentbernat.github.io/lldpd/'
  url 'http://media.luffy.cx/files/lldpd/lldpd-0.7.12.tar.gz'
  sha1 '2d602aaaad01d1f76f8e1c87e48dca1c6725ba78'

  bottle do
    sha1 "c77debb346c325a44b8e91a7b983b251dc1db76f" => :yosemite
    sha1 "52737f6933bc2d052ece4877d36c021fd6e648c1" => :mavericks
    sha1 "6d6d4f6d4b7e23b9f707db180c99c24174ff9293" => :mountain_lion
  end

  option 'with-snmp', "Build SNMP subagent support"
  option 'with-json', "Build JSON support for lldpcli"

  depends_on 'pkg-config' => :build
  depends_on 'readline'
  depends_on 'libevent'
  depends_on 'net-snmp' if build.with? "snmp"
  depends_on 'jansson'  if build.with? "json"

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
    return <<-EOS.undent
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
