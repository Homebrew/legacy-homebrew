class Sdcc < Formula
  desc "ANSI C compiler for Intel 8051, Maxim 80DS390, and Zilog Z80"
  homepage "http://sdcc.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/sdcc/sdcc/3.5.0/sdcc-src-3.5.0.tar.bz2"
  sha256 "f82978d1614244b22e093402c0a4de1f688a07c807b2980126c964eb3df85fa9"

  head "https://sdcc.svn.sourceforge.net/svnroot/sdcc/trunk/sdcc/"

  bottle do
    revision 1
    sha256 "d46fdad8f291ea90162e7218ec3d43468de8b85680da5f1088617be8521005f5" => :el_capitan
    sha256 "b5cd6950c3dd7b2d7399e0a7eabdd02992a34b8ec0c1c9fc9e46ddc7f561fce6" => :yosemite
    sha256 "73aecffe0f2ec715f532c09ef0f95d3a045582cc65b5e10c48208eac5bfe655e" => :mavericks
  end

  option "with-avr-port", "Enables the AVR port (UNSUPPORTED, MAY FAIL)"
  option "with-xa51-port", "Enables the xa51 port (UNSUPPORTED, MAY FAIL)"

  deprecated_option "enable-avr-port" => "with-avr-port"
  deprecated_option "enable-xa51-port" => "with-xa51-port"

  depends_on "gputils"
  depends_on "boost"

  # SDCC Doesn't build huge-stack-auto by default for mcs51, but it
  # is needed by Contiki and others. This simple patch enables it to build.
  patch do
    url "https://gist.githubusercontent.com/anonymous/5042275/raw/a2e084f29cd4ad9cd95e38683209991b7ac038d3/sdcc-huge-stack-auto.diff"
    sha256 "4fa5bf4d3f8f57682246918a06eb780e163b7207dc2cad4133d4017ae892bf6a"
  end

  def install
    args = %W[--prefix=#{prefix}]
    args << "--enable-avr-port" if build.with? "avr-port"
    args << "--enable-xa51-port" if build.with? "xa51-port"

    system "./configure", *args
    system "make", "all"
    system "make", "install"
    rm Dir["#{bin}/*.el"]
  end

  test do
    system "#{bin}/sdcc", "-v"
  end
end
