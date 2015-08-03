class Audiofile < Formula
  desc "Reads and writes many common audio file formats"
  homepage "http://www.68k.org/~michael/audiofile/"
  url "http://audiofile.68k.org/audiofile-0.3.6.tar.gz"
  sha256 "cdc60df19ab08bfe55344395739bb08f50fc15c92da3962fac334d3bff116965"

  bottle do
    cellar :any
    sha1 "3ee5b808776b2ee6269aad02db795e8da61fa181" => :yosemite
    sha1 "a15e1ae96b15c18c62cfd19e387eb5d21f0992f2" => :mavericks
    sha1 "9994dc853442647fee82bf7291df0a2d35b93d16" => :mountain_lion
  end

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
      ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
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

    unless File.exist?(conv_bin) && File.exist?(inn) && File.exist?(info_bin)
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
