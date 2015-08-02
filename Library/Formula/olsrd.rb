class Olsrd < Formula
  desc "Implementation of the optimized link state routing protocol"
  homepage "http://www.olsr.org"
  url "http://www.olsr.org/releases/0.9/olsrd-0.9.0.2.tar.bz2"
  sha256 "cc464b29c7740354d815d5faa753fd27c0677d71e8eb42e78abc382996892845"

  bottle do
    cellar :any
    sha256 "102397f5d03ba024aad0c4bb6b427aaeb52e1a3e744e6dbb84d574302ebe99cf" => :yosemite
    sha256 "6c041f2004d2fb432123128a220146f8720682cbcc75e799194387efa06be964" => :mavericks
    sha256 "f4803624b8d9614efb3e8b731043ad7bb98d60ffc4ffc84b18008c9a43ee899a" => :mountain_lion
  end

  def install
    inreplace "make/Makefile.osx",
              "PLUGIN_FULLNAME ?= $(PLUGIN_NAME).so.$(PLUGIN_VER)",
              "PLUGIN_FULLNAME ?= $(PLUGIN_NAME).$(PLUGIN_VER).dylib"

    lib.mkpath
    args = %W[
      DESTDIR=#{prefix}
      USRDIR=#{prefix}
      LIBDIR=#{lib}
      ETCDIR=#{etc}
    ]
    system "make", "build_all", *args
    system "make", "install_all", *args
  end

  plist_options :startup => true, :manual => "olsrd -f #{HOMEBREW_PREFIX}/etc/olsrd.conf"

  def startup_plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{HOMEBREW_PREFIX}/sbin/olsrd</string>
          <string>-f</string>
          <string>#{etc}/olsrd.conf</string>
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

  test do
    assert_match version.to_s, shell_output("#{sbin}/olsrd", 1)
  end
end
