class Pulseaudio < Formula
  desc "Sound system for POSIX OSes"
  homepage "http://pulseaudio.org"
  url "http://www.freedesktop.org/software/pulseaudio/releases/pulseaudio-6.0.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/p/pulseaudio/pulseaudio_6.0.orig.tar.xz"
  sha256 "b50640e0b80b1607600accfad2e45aabb79d379bf6354c9671efa2065477f6f6"

  bottle do
    sha256 "d57bc83ad5fc738faeb8fe64b03139e1164cecff7cc969b17f4b551e31ff25fa" => :yosemite
    sha256 "5e7826508922b199bf1027e4961c3a747a97b2f73496993bae3c3453f53fa442" => :mavericks
    sha256 "1f2204be6e1ecd20380a6593dd4e49608e1d7be42caf60d29c43ec1587dae97e" => :mountain_lion
  end

  head do
    url "http://anongit.freedesktop.org/git/pulseaudio/pulseaudio.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "intltool" => :build
    depends_on "gettext" => :build
  end

  option "with-nls", "Build with native language support"
  option :universal

  depends_on "pkg-config" => :build

  if build.with? "nls"
    depends_on "intltool" => :build
    depends_on "gettext" => :build
  end

  depends_on "libtool" => :run
  depends_on "json-c"
  depends_on "libsndfile"
  depends_on "libsamplerate"
  depends_on "openssl"

  depends_on :x11 => :optional
  depends_on "glib" => :optional
  depends_on "gconf" => :optional
  depends_on "d-bus" => :optional
  depends_on "gtk+3" => :optional
  depends_on "jack" => :optional

  # i386 patch per MacPorts
  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/15fa4f03/pulseaudio/i386.patch"
    sha256 "d3a2180600a4fbea538949b6c4e9e70fe7997495663334e50db96d18bfb1da5f"
  end

  fails_with :clang do
    build 421
    cause "error: thread-local storage is unsupported for the current target"
  end

  def install
    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --enable-coreaudio-output
      --disable-neon-opt
      --with-mac-sysroot=/
    ]

    args << "--with-mac-sysroot=#{MacOS.sdk_path}"
    args << "--with-mac-version-min=#{MacOS.version}"
    args << "--disable-nls" if build.without? "nls"

    if build.universal?
      args << "--enable-mac-universal"
      ENV.universal_binary
    end

    if build.head?
      # autogen.sh runs bootstrap.sh then ./configure
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    system bin/"pulseaudio", "--dump-modules"
  end
end
