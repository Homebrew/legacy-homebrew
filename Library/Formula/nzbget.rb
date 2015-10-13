class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "http://nzbget.net/"
  url "https://github.com/nzbget/nzbget/releases/download/v16.0/nzbget-16.0-src.tar.gz"
  sha256 "95bf4d1b888c631da06ef2699219c855a8d5433a3907791aee0d075c413ccdd0"

  head "https://github.com/nzbget/nzbget.git"

  bottle do
    sha256 "f762e81295088fd491d736c757d22d5de28ede8b40006ab551abca1c5ab2a65a" => :el_capitan
    sha256 "4037da3bde9922618641e167d9c8bdfffd258ef1e8a7a4d93d2fc86eaa7d05ee" => :yosemite
    sha256 "3f877646235a15f06097e5669b4cee0c5df366e667b337904c68034f019bb4f3" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"

  needs :cxx11

  fails_with :clang do
    build 500
    cause <<-EOS.undent
      Clang older than 5.1 requires flexible array members to be POD types.
      More recent versions require only that they be trivially destructible.
      EOS
  end

  def install
    ENV.cxx11

    # Tell configure to use OpenSSL
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-tlslib=OpenSSL"
    system "make"
    ENV.j1
    system "make", "install"
    pkgshare.install_symlink "nzbget.conf" => "webui/nzbget.conf"
    etc.install "nzbget.conf"
  end

  plist_options :manual => "nzbget"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/nzbget</string>
        <string>-s</string>
        <string>-o</string>
        <string>OutputMode=Log</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
    </dict>
    </plist>
    EOS
  end

  test do
    # Start nzbget as a server in daemon-mode
    system "#{bin}/nzbget", "-D"
    # Query server for version information
    system "#{bin}/nzbget", "-V"
    # Shutdown server daemon
    system "#{bin}/nzbget", "-Q"
  end
end
