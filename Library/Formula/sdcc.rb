require 'formula'

class Sdcc < Formula
  homepage 'http://sdcc.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/sdcc/sdcc/3.3.0/sdcc-src-3.3.0.tar.bz2'
  sha1 'beed1b8c73f13344e018f48b1563ff2a948b70cf'

  head 'https://sdcc.svn.sourceforge.net/svnroot/sdcc/trunk/sdcc/'

  depends_on 'gputils'
  depends_on 'boost'

  option 'enable-avr-port', "Enables the AVR port (UNSUPPORTED, MAY FAIL)"
  option 'enable-xa51-port', "Enables the xa51 port (UNSUPPORTED, MAY FAIL)"

  def patches
    # SDCC Doesn't build huge-stack-auto by default for mcs51, but it
    # is needed by Contiki and others. This simple patch enables it to build.
    'https://gist.github.com/anonymous/5042275/raw/a2e084f29cd4ad9cd95e38683209991b7ac038d3/sdcc-huge-stack-auto.diff'
  end

  def install
    args = ["--prefix=#{prefix}", '--disable-sdcdb']

    args << '--enable-avr-port' if build.include? 'enable-avr-port'
    args << '--enable-xa51-port' if build.include? 'enable-xa51-port'

    system "./configure", *args
    system "make all"
    system "make install"
  end

  test do
    system "#{bin}/sdcc", "-v"
  end
end
