require 'formula'

class Avrdude < Formula
  homepage 'http://savannah.nongnu.org/projects/avrdude/'
  url 'http://download.savannah.gnu.org/releases/avrdude/avrdude-6.1.tar.gz'
  sha1 '15525cbff5918568ef3955d871dbb94feaf83c79'

  head do
    url 'svn://svn.savannah.nongnu.org/avrdude/trunk/avrdude/'

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  depends_on :macos => :snow_leopard # needs GCD/libdispatch
  depends_on 'libusb-compat'
  depends_on 'libftdi0'
  depends_on 'libelf'
  depends_on 'libhid' => :optional

  def install
    system "./bootstrap" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
