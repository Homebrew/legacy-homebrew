class Nzbget < Formula
  desc "Binary newsgrabber for nzb files"
  homepage "http://nzbget.net/"
  url "https://downloads.sourceforge.net/project/nzbget/nzbget-stable/15.0/nzbget-15.0.tar.gz"
  sha256 "3ef13f3e5917e4cda19c4fc0cd37e79967a19b4e3448c239ff24e37712a6cc0a"

  head "https://github.com/nzbget/nzbget.git"

  bottle do
    revision 1
    sha1 "a99dad2495312ed2b6a44f094866edec6de3c60a" => :yosemite
    sha1 "c88d1e24b4a32652154cfce1ed3e9eb1215f9259" => :mavericks
    sha1 "254d5ba9030626f11fc3891b8b684917295647f9" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "libsigc++"

  fails_with :clang do
    build 500
    cause <<-EOS.undent
      Clang older than 5.1 requires flexible array members to be POD types.
      More recent versions require only that they be trivially destructible.
      EOS
  end

  resource "libpar2" do
    url "https://launchpad.net/libpar2/trunk/0.4/+download/libpar2-0.4.tar.gz"
    sha256 "316d6f0eb31eb896f5546171c2e86801aeffe5ae5e2decffc17f0018346796d4"
  end

  def install
    resource("libpar2").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--prefix=#{libexec}/lp2"
      system "make", "install"
    end

    # Tell configure where libpar2 is, and tell it to use OpenSSL
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-libpar2-includes=#{libexec}/lp2/include",
                          "--with-libpar2-libraries=#{libexec}/lp2/lib",
                          "--with-tlslib=OpenSSL"
    system "make"
    ENV.j1
    system "make", "install"
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
