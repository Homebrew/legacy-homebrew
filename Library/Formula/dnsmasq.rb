require 'formula'

class Dnsmasq < Formula
  homepage 'http://www.thekelleys.org.uk/dnsmasq/doc.html'
  url 'http://www.thekelleys.org.uk/dnsmasq/dnsmasq-2.71.tar.gz'
  sha1 'b0a39f66557c966629a0ed9282cd87df8f409004'

  bottle do
    sha1 "1f8dbfd55734f92bc19c31464b7c494fa475b07a" => :mavericks
    sha1 "2ce5814f8efdc77be667ddfa44f9c759fbc60a8c" => :mountain_lion
    sha1 "75dd1e027e329cbdd5817fe2389b5f8a768c5c79" => :lion
  end

  option 'with-idn', 'Compile with IDN support'

  depends_on "libidn" if build.with? "idn"
  depends_on 'pkg-config' => :build

  def install
    ENV.deparallelize

    # Fix etc location
    inreplace "src/config.h", "/etc/dnsmasq.conf", "#{etc}/dnsmasq.conf"

    # Optional IDN support
    if build.with? "idn"
      inreplace "src/config.h", "/* #define HAVE_IDN */", "#define HAVE_IDN"
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
        <key>KeepAlive</key>
        <dict>
          <key>NetworkState</key>
          <true/>
        </dict>
      </dict>
    </plist>
    EOS
  end
end
