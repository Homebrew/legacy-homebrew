require "formula"

class Dovecot < Formula
  homepage "http://dovecot.org/"
  url "http://dovecot.org/releases/2.2/dovecot-2.2.13.tar.gz"
  mirror "http://fossies.org/linux/misc/dovecot-2.2.13.tar.gz"
  sha1 "ee8efc77cb9d502dc416ae4fba242adc5f01c163"
  revision 1

  bottle do
    revision 1
    sha1 "54f958d592b09f6765a5b717ea0746ff9096a526" => :mavericks
    sha1 "19a2b6d3f75e01dc1f82503a527c4e20d21eb678" => :mountain_lion
    sha1 "c15272453ce3fd1a1c16d91948d9724ba921d42e" => :lion
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
