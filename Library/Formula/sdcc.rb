class Sdcc < Formula
  desc "ANSI C compiler for Intel 8051, Maxim 80DS390, and Zilog Z80"
  homepage "http://sdcc.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/sdcc/sdcc/3.5.0/sdcc-src-3.5.0.tar.bz2"
  sha256 "f82978d1614244b22e093402c0a4de1f688a07c807b2980126c964eb3df85fa9"

  head "https://sdcc.svn.sourceforge.net/svnroot/sdcc/trunk/sdcc/"

  bottle do
    sha256 "f22ecc49004e7e760c3510d90a8818289974c702e18887a46d04104d11e3a69b" => :yosemite
    sha256 "2ad5b170ee4c018faeb6c5ec3a1b7dc01a34cec0b635ea8c654f5d290b801f19" => :mavericks
    sha256 "79f62fa7c8972a9b8b25bf1a96b92262ddc916517bda7567b2c761c5ea211ffe" => :mountain_lion
  end

  depends_on "gputils"
  depends_on "boost"

  option "enable-avr-port", "Enables the AVR port (UNSUPPORTED, MAY FAIL)"
  option "enable-xa51-port", "Enables the xa51 port (UNSUPPORTED, MAY FAIL)"

  # SDCC Doesn't build huge-stack-auto by default for mcs51, but it
  # is needed by Contiki and others. This simple patch enables it to build.
  patch do
    url "https://gist.githubusercontent.com/anonymous/5042275/raw/a2e084f29cd4ad9cd95e38683209991b7ac038d3/sdcc-huge-stack-auto.diff"
    sha256 "4fa5bf4d3f8f57682246918a06eb780e163b7207dc2cad4133d4017ae892bf6a"
  end

  def install
    args = ["--prefix=#{prefix}"]

    args << "--enable-avr-port" if build.include? "enable-avr-port"
    args << "--enable-xa51-port" if build.include? "enable-xa51-port"

    system "./configure", *args
    system "make", "all"
    system "make", "install"
    rm Dir["#{bin}/*.el"]
  end

  test do
    system "#{bin}/sdcc", "-v"
  end
end
