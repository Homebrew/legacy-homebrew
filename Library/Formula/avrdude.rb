require 'formula'

class Avrdude < Formula
  homepage 'http://savannah.nongnu.org/projects/avrdude/'
  url 'http://download.savannah.gnu.org/releases/avrdude/avrdude-5.11.1.tar.gz'
  sha1 '330b3a38d3de6c54d4866819ffb6924ed3728173'

  head 'svn://svn.savannah.nongnu.org/avrdude/trunk/avrdude/'

  option 'with-usb', 'Compile AVRDUDE with USB support.'
  option 'with-ftdi', 'Compile AVRDUDE with FTDI support.'

  depends_on 'libusb-compat' if build.include? 'with-usb'
  depends_on 'libftdi' if build.include? 'with-ftdi'

  if build.head?
    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
