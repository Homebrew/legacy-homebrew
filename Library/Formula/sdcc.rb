require 'formula'

class Sdcc < Formula
  homepage 'http://sdcc.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/sdcc/sdcc/3.4.0/sdcc-src-3.4.0.tar.bz2'
  sha1 '469649acbd22376933154ab1e16d0a59806594c4'

  head 'https://sdcc.svn.sourceforge.net/svnroot/sdcc/trunk/sdcc/'

  depends_on 'gputils'
  depends_on 'boost'

  option 'enable-avr-port', "Enables the AVR port (UNSUPPORTED, MAY FAIL)"
  option 'enable-xa51-port', "Enables the xa51 port (UNSUPPORTED, MAY FAIL)"

  # SDCC Doesn't build huge-stack-auto by default for mcs51, but it
  # is needed by Contiki and others. This simple patch enables it to build.
  patch do
    url "https://gist.githubusercontent.com/anonymous/5042275/raw/a2e084f29cd4ad9cd95e38683209991b7ac038d3/sdcc-huge-stack-auto.diff"
    sha1 "57f638d8d81c4bb1ea9a74a006363b881f5aab8c"
  end

  def install
    args = ["--prefix=#{prefix}"]

    args << '--enable-avr-port' if build.include? 'enable-avr-port'
    args << '--enable-xa51-port' if build.include? 'enable-xa51-port'

    system "./configure", *args
    system "make all"
    system "make install"
    rm Dir["#{bin}/*.el"]
  end

  test do
    system "#{bin}/sdcc", "-v"
  end
end
