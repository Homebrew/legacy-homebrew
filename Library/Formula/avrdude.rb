require 'formula'

class Avrdude <Formula
  url 'http://mirror.lihnidos.org/GNU/savannah/avrdude/avrdude-5.10.tar.gz'
  homepage 'http://savannah.nongnu.org/projects/avrdude/'
  md5 '69b082683047e054348088fd63bad2ff'

  depends_on 'libusb-compat' if ARGV.include? '--with-usb'

  def options
    [['--with-usb', 'Compile AVRDUDE with USB support.']]
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
