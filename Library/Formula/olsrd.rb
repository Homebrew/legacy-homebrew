class Olsrd < Formula
  desc "Implementation of the optimized link state routing protocol"
  homepage "http://www.olsr.org"
  url "http://www.olsr.org/releases/0.9/olsrd-0.9.0.2.tar.bz2"
  sha256 "cc464b29c7740354d815d5faa753fd27c0677d71e8eb42e78abc382996892845"

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
