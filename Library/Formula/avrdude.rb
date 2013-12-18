require 'formula'

class Avrdude < Formula
  homepage 'http://savannah.nongnu.org/projects/avrdude/'
  url 'http://download.savannah.gnu.org/releases/avrdude/avrdude-6.0.1.tar.gz'
  sha1 'b0f440f1b1ba3890da6e5b752003ca99e550e3bf'

  head do
    url 'svn://svn.savannah.nongnu.org/avrdude/trunk/avrdude/'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on 'libusb-compat'
  depends_on 'libftdi0'
  depends_on 'libelf'

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
