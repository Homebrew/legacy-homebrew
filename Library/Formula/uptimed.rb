class Uptimed < Formula
  desc "Utility to track your highest uptimes"
  homepage "https://github.com/rpodgorny/uptimed/"
  url "https://github.com/rpodgorny/uptimed/archive/v0.4.0.tar.gz"
  sha256 "26891965bb499065e34072cecd3eb8087102b1c05f530c8fe8504a07c722f9bf"

  bottle do
    sha256 "cd0bd1b637357439872b01eeb3b32e10c111dd630b711bbd0ea7488f66c68a64" => :yosemite
    sha256 "3ce223958f06002df59fc9738b539832a9198a9f574b86f8ceab3c4f38936d6c" => :mavericks
    sha256 "ad260249020068e03bf37c944db598799ed08d57f485ae78d7831c3f9f027cf2" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    # Per MacPorts
    inreplace "Makefile", "/var/spool/uptimed", "#{var}/uptimed"
    inreplace "libuptimed/urec.h", "/var/spool", var
    inreplace "etc/uptimed.conf-dist", "/var/run", "#{var}/uptimed"
    system "make", "install"
  end

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <false/>
        <key>WorkingDirectory</key>
        <string>#{opt_prefix}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/uptimed</string>
          <string>-f</string>
          <string>-p</string>
          <string>#{var}/run/uptimed.pid</string>
        </array>
      </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/uprecords"
  end
end

