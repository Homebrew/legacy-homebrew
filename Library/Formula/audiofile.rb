class Audiofile < Formula
  desc "Reads and writes many common audio file formats"
  homepage "http://www.68k.org/~michael/audiofile/"
  url "http://audiofile.68k.org/audiofile-0.3.6.tar.gz"
  sha256 "cdc60df19ab08bfe55344395739bb08f50fc15c92da3962fac334d3bff116965"

  bottle do
    cellar :any
    sha256 "6fb50402d26b8122f6eb424bd0cb359a903451321f331e5a2f0fa19fc24759e2" => :el_capitan
    sha256 "0b7f9bd2023f2b52e4b3f7c03ddd822b0866874325adacfa10b582740e070cdc" => :yosemite
    sha256 "a03ebac03c59a9a65482cfa420b54f6be76bfae546ceaa1e70340ef0d02d42a7" => :mavericks
    sha256 "b68287cea599e95d784529b79a2b17fea366bc756d9a84ee8a77c06fcffda773" => :mountain_lion
  end

  head do
    url "https://github.com/mpruett/audiofile.git"
    depends_on "asciidoc" => :build
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "with-lcov", "Enable Code Coverage support using lcov"
  option "with-test", "Run the test suite during install (~30sec)"

  deprecated_option "with-check" => "with-test"

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
    system "make", "check" if build.with? "test"
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
