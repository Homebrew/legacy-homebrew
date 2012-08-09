require 'formula'

class Avrdude < Formula
  homepage 'http://savannah.nongnu.org/projects/avrdude/'
  url 'http://download.savannah.gnu.org/releases/avrdude/avrdude-5.11.1.tar.gz'
  md5 '3a43e288cb32916703b6945e3f260df9'

  option 'with-usb', 'Compile AVRDUDE with USB support.'

  depends_on 'libusb-compat' if build.include? '--with-usb'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
