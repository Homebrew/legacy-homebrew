class BaculaFd < Formula
  desc "Network backup solution"
  homepage "http://www.bacula.org/"
  url "https://downloads.sourceforge.net/project/bacula/bacula/7.0.5/bacula-7.0.5.tar.gz"
  sha256 "1457849eb33011b43371801b62ffa13d29bebe51be8d5a36da563b87bb094a49"

  bottle do
    revision 1
    sha256 "7b1f201752034bc00cc8410454bb1b7ce9fc991545dddf485e97492612e006ad" => :el_capitan
    sha256 "80b5c4fafcfb0662c5cf6792d65ad036a3df7b9390b699499592a89ae17ec0a9" => :yosemite
    sha256 "7e9e7ac750ccc8f23a1f05a9bf9245b42c153e2be293ca183e741f758defb9fc" => :mavericks
  end

  depends_on "readline"
  depends_on "openssl"

  def install
    # * sets --disable-conio in order to force the use of readline
    #   (conio support not tested)
    # * working directory in /var/lib/bacula, reasonable place that
    #   matches Debian's location.
    readline = Formula["readline"].opt_prefix
    system "./configure", "--prefix=#{prefix}",
                          "--sbindir=#{bin}",
                          "--with-working-dir=#{var}/lib/bacula",
                          "--with-pid-dir=#{HOMEBREW_PREFIX}/var/run",
                          "--enable-client-only",
                          "--disable-conio",
                          "--with-readline=#{readline}"

    system "make"
    system "make", "install"

    # Ensure var/run exists:
    (var + "run").mkpath

    # Create the working directory:
    (var + "lib/bacula").mkpath
  end

  plist_options :startup => true, :manual => "bacula-fd"

  def plist; <<-EOS.undent
    <?xml version="0.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>RunAtLoad</key>
        <true/>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/bacula-fd</string>
          <string>-f</string>
        </array>
        <key>UserName</key>
        <string>root</string>
      </dict>
    </plist>
  EOS
  end
end
