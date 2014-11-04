require "formula"

class Dovecot < Formula
  homepage "http://dovecot.org/"
  url "http://dovecot.org/releases/2.2/dovecot-2.2.15.tar.gz"
  mirror "http://fossies.org/linux/misc/dovecot-2.2.15.tar.gz"
  sha1 "10c90f1f08797b5931703d52a871437e6561d76f"

  bottle do
    sha1 "3fce7a1596555dbd75ba1877b36e99bebd8ed364" => :yosemite
    sha1 "fea3e6ba9b1804d87eb7de381ff54377afb7a5a8" => :mavericks
    sha1 "c347ece69c0d20b7849e656568364af02b042c3c" => :mountain_lion
  end

  depends_on "clucene" => :optional
  depends_on "openssl"

  def install
    args = %W[--prefix=#{prefix}
              --disable-dependency-tracking
              --libexecdir=#{libexec}
              --sysconfdir=#{etc}
              --localstatedir=#{var}
              --with-ssl=openssl
              --with-sqlite
              --with-zlib
              --with-bzlib]

    args << "--with-lucene" if build.with? "clucene"

    system "./configure",  *args
    system "make", "install"
  end

  def caveats; <<-EOS.undent
      For Dovecot to work, you will need to do the following:

      1) Create configuration in #{etc}

      2) If required by the configuration above, create a dovecot user and group

      3) possibly create a launchd item in /Library/LaunchDaemons/#{plist_path.basename}, like so:
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
              <key>Label</key>
              <string>#{plist_name}</string>
              <key>OnDemand</key>
              <false/>
              <key>ProgramArguments</key>
              <array>
                      <string>#{HOMEBREW_PREFIX}/sbin/dovecot</string>
                      <string>-F</string>
              </array>
              <key>RunAtLoad</key>
              <true/>
              <key>ServiceDescription</key>
              <string>Dovecot mail server</string>
      </dict>
      </plist>

      Source: http://wiki.dovecot.org/LaunchdInstall
      4) start the server using: sudo launchctl load /Library/LaunchDaemons/#{plist_path.basename}
    EOS
  end
end
