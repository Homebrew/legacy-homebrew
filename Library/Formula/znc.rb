class Znc < Formula
  desc "Advanced IRC bouncer"
  homepage "http://wiki.znc.in/ZNC"
  url "http://znc.in/releases/archive/znc-1.6.1.tar.gz"
  mirror "https://github.com/znc/znc/archive/znc-1.6.1.tar.gz"
  sha256 "ba49397364f48d6d32ae5242bc1166f21d972f85dd390d6bbe68a63ecbb6c140"

  bottle do
    sha256 "4127f180543c057c53bee581634dd0e26bb4419858240ffa228365129ee8c773" => :yosemite
    sha256 "7089f0213b44b434300476786a96e0e459d00033f26053faeefc764991edbd9f" => :mavericks
    sha256 "67f5a568ddb3b3330e3237a139b484792cf04e7a725f56d644aa7e67f6a0a906" => :mountain_lion
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
