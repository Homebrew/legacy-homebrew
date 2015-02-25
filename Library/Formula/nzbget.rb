class Nzbget < Formula
  homepage "http://nzbget.net/"
  url "https://downloads.sourceforge.net/project/nzbget/nzbget-stable/14.2/nzbget-14.2.tar.gz"
  sha1 "25adf5565d228cf1cbb8fa305732f61a6f869aa0"

  devel do
    url "https://downloads.sourceforge.net/project/nzbget/nzbget-testing/15.0-r1207/nzbget-15.0-testing-r1207.tar.gz"
    sha1 "37f9d069df4bab4a78a1999434a2152aae6c2577"
    version "15.0-r1207"
  end

  head "https://nzbget.svn.sourceforge.net/svnroot/nzbget/trunk"

  bottle do
    sha1 "945e2347812f139dd4c79d9c76d2ee2986a68228" => :yosemite
    sha1 "d112ad7a7c1b68cdc61075f154af707198ec23d6" => :mavericks
    sha1 "d0527d44dc138f2e5e07e4b9e50486a1282fd47d" => :mountain_lion
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
    sha1 "c4a5318edac0898dcc8b1d90668cfca2ccfe0375"
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
