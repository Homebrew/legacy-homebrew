class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "http://wiki.znc.in/ZNC"
  url "http://znc.in/releases/archive/znc-1.6.3.tar.gz"
  mirror "https://github.com/znc/znc/archive/znc-1.6.3.tar.gz"
  sha256 "631c46de76fe601a41ef7676bc974958e9a302b72b25fc92b4a603a25d89b827"

  bottle do
    sha256 "1e190212ca7079d83a5de38a6d5fd4a7f3d76dc372cce250758ae05524e52856" => :el_capitan
    sha256 "a6f958bcf993587a1d57cdd1cfb5d5c457fd61690a4c04e13853b238c5bb8563" => :yosemite
    sha256 "ba52c547e66c05a2505d97726d41aa17b13232e8f52543a478ce7fa777da05e7" => :mavericks
  end

  head do
    url "https://github.com/znc/znc.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-debug", "Compile ZNC with debug support"
  option "with-icu4c", "Build with icu4c for charset support"

  deprecated_option "enable-debug" => "with-debug"

  depends_on "pkg-config" => :build
  depends_on "openssl"
  depends_on "icu4c" => :optional

  needs :cxx11

  def install
    ENV.cxx11
    # These need to be set in CXXFLAGS, because ZNC will embed them in its
    # znc-buildmod script; ZNC's configure script won't add the appropriate
    # flags itself if they're set in superenv and not in the environment.
    ENV.append "CXXFLAGS", "-std=c++11"
    ENV.append "CXXFLAGS", "-stdlib=libc++" if ENV.compiler == :clang

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
          <string>#{opt_bin}/znc</string>
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
