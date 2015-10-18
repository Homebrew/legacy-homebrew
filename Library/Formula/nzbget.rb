class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "http://nzbget.net/"
  url "https://github.com/nzbget/nzbget/releases/download/v16.0/nzbget-16.0-src.tar.gz"
  sha256 "95bf4d1b888c631da06ef2699219c855a8d5433a3907791aee0d075c413ccdd0"

  head "https://github.com/nzbget/nzbget.git"

  bottle do
    cellar :any
    sha256 "beed81c6b0c08725384b27285a13672b1c264228f025028ce81b9c6cf0c710b9" => :el_capitan
    sha256 "b8f8f1cf8c569dc0b7cb7ed186b506dae589468e7631afa0fc9e0ba1f12064ec" => :yosemite
    sha256 "d67d69333f76517db3b121d1926543c3d6d2bf538f12738fd8757cb2c01fcbf1" => :mavericks
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
