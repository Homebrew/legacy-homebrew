require 'formula'

class Avrdude < Formula
  homepage 'http://savannah.nongnu.org/projects/avrdude/'
  url 'http://download.savannah.gnu.org/releases/avrdude/avrdude-5.11.1.tar.gz'
  sha1 '330b3a38d3de6c54d4866819ffb6924ed3728173'

  option 'with-usb', 'Compile AVRDUDE with USB support.'

  depends_on 'libusb-compat' if build.include? 'with-usb'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
