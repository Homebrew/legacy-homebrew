require 'formula'

class Avrdude < Formula
  url 'http://download.savannah.gnu.org/releases/avrdude/avrdude-5.11.tar.gz'
  homepage 'http://savannah.nongnu.org/projects/avrdude/'
  md5 'ba62697270b1292146dc56d462f5da14'

  depends_on 'libusb-compat' if ARGV.include? '--with-usb'

  def options
    [['--with-usb', 'Compile AVRDUDE with USB support.']]
  end

  def install
    ENV.j1 # See http://github.com/mxcl/homebrew/issues/6915
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
