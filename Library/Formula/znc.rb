class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "http://wiki.znc.in/ZNC"
  url "http://znc.in/releases/archive/znc-1.6.0.tar.gz"
  sha1 "548d31fa63d50494bdf4b1d3c0f43a8ceda66849"

  head do
    url "https://github.com/znc/znc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  bottle do
    sha1 "4f695db064f9971100f917f35ab2bcb9ba758f84" => :yosemite
    sha1 "6e3799aae4b598b61062eb0b67744a5caa5f264e" => :mavericks
    sha1 "83597cccd275a3a4bf8fcc5d8dd5c9048403869a" => :mountain_lion
  end

  option "with-debug", "Compile ZNC with debug support"
  option "with-icu4c", "Build with icu4c for charset support"

  deprecated_option "enable-debug" => "with-debug"

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "icu4c" => :optional

  def install
    ENV.cxx11
    args = ["--prefix=#{prefix}"]
    args << "--enable-debug" if build.with? "debug"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  plist_options :manual => "znc --foreground"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{bin}/znc</string>
          <string>--foreground</string>
        </array>
        <key>StandardErrorPath</key>
        <string>#{var}/log/znc.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/znc.log</string>
        <key>RunAtLoad</key>
        <true/>
        <key>StartInterval</key>
        <integer>300</integer>
      </dict>
    </plist>
    EOS
  end

  test do
    mkdir ".znc"
    system bin/"znc", "--makepem"
    assert File.exist?(".znc/znc.pem")
  end
end
