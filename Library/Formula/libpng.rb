require 'formula'

class Libpng < Formula
  homepage 'http://www.libpng.org/pub/png/libpng.html'
  url 'http://downloads.sf.net/project/libpng/libpng15/older-releases/1.5.13/libpng-1.5.13.tar.gz'
  sha1 '43a86bc5ba927618fd6c440bc4fd770d87d06b80'

  keg_only :provided_pre_mountain_lion

  option :universal

  bottle do
    revision 1
    sha1 '7aea90896440277ef84dfaf35cc9f08cfa024331' => :mountain_lion
    sha1 '8cb9f898522ea356a8dbd8dca13a8ede31f9140c' => :lion
    sha1 'fc51e3ebca7b1b3d57c54957e10c22e2900585f3' => :snow_leopard
  end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
