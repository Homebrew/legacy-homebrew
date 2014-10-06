require "formula"

class Dnsmasq < Formula
  homepage "http://www.thekelleys.org.uk/dnsmasq/doc.html"
  url "http://www.thekelleys.org.uk/dnsmasq/dnsmasq-2.72.tar.gz"
  sha1 "c2dc54b142ec5676d6e22951bc5b61863b0503fe"

  bottle do
    sha1 "b4bb00ef3c8fd8ffa48a08b0de4f95fa5cef09d2" => :mavericks
    sha1 "6ae8c98b3c600c1a6f1f0263a5d7612887d8e768" => :mountain_lion
    sha1 "66c145b8ed68c93ae0e7dcbc755b2151f94f5772" => :lion
  end

  option "with-idn", "Compile with IDN support"
  option "with-dnssec", "Compile with DNSSEC support"

  depends_on "libidn" if build.with? "idn"
  depends_on "nettle" if build.with? "dnssec"
  depends_on "pkg-config" => :build

  def install
    ENV.deparallelize

    # Fix etc location
    inreplace "src/config.h", "/etc/dnsmasq.conf", "#{etc}/dnsmasq.conf"

    # Optional IDN support
    if build.with? "idn"
      inreplace "src/config.h", "/* #define HAVE_IDN */", "#define HAVE_IDN"
    end

    # Optional DNSSEC support
    if build.with? "dnssec"
      inreplace "src/config.h", "/* #define HAVE_DNSSEC */", "#define HAVE_DNSSEC"
    end

    # Fix compilation on Lion
    ENV.append_to_cflags "-D__APPLE_USE_RFC_3542" if MacOS.version >= :lion
    inreplace "Makefile" do |s|
      s.change_make_var! "CFLAGS", ENV.cflags
    end

    system "make", "install", "PREFIX=#{prefix}"

    prefix.install "dnsmasq.conf.example"
  end

  def caveats; <<-EOS.undent
    To configure dnsmasq, copy the example configuration to #{etc}/dnsmasq.conf
    and edit to taste.

      cp #{opt_prefix}/dnsmasq.conf.example #{etc}/dnsmasq.conf
    EOS
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_sbin}/dnsmasq</string>
          <string>--keep-in-foreground</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>KeepAlive</key>
        <true/>
      </dict>
    </plist>
    EOS
  end
end
