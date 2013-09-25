require 'formula'

class Avrdude < Formula
  homepage 'http://savannah.nongnu.org/projects/avrdude/'
  url 'http://download.savannah.gnu.org/releases/avrdude/avrdude-5.11.1.tar.gz'
  sha1 '330b3a38d3de6c54d4866819ffb6924ed3728173'

  head do
    url 'svn://svn.savannah.nongnu.org/avrdude/trunk/avrdude/'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end


  depends_on 'libusb-compat'
  depends_on 'libftdi0'

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
