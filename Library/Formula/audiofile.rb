class Audiofile < Formula
  homepage "http://www.68k.org/~michael/audiofile/"
  url "http://audiofile.68k.org/audiofile-0.3.6.tar.gz"
  sha1 "3aba3ef724b1b5f88cfc20ab9f8ce098e6c35a0e"

  head do
    url "https://github.com/mpruett/audiofile.git"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-lcov", "Enable Code Coverage support using lcov"
  option "with-check", "Run the test suite during install ~30sec"

  depends_on "lcov" => :optional

  def install
    if build.head?
      inreplace "autogen.sh", "libtool", "glibtool"
      ENV["XML_CATALOG_FILES"] = "#{HOMEBREW_PREFIX}/etc/xml/catalog"
    end

    configure = build.head? ? "./autogen.sh" : "./configure"
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}"]
    args << "--enable-coverage" if build.with? "lcov"
    system configure, *args
    system "make"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    inn  = "/System/Library/Sounds/Glass.aiff"
    out  = "Glass.wav"
    conv_bin = "#{bin}/sfconvert"
    info_bin = "#{bin}/sfinfo"

    unless File.exist?(conv_bin) and File.exist?(inn) and File.exist?(info_bin)
      opoo <<-EOS.undent
        One of the following files could not be located, and so
        the test was not executed:
           #{inn}
           #{conv_bin}
           #{info_bin}

        Audiofile can also be tested at build-time:
          brew install -v audiofile --with-check
      EOS
      return
    end

    system conv_bin, inn, out, "format", "wave"
    system info_bin, "--short", "--reporterror", out
  end
end
