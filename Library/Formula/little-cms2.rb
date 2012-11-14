require 'formula'

class LittleCms2 < Formula
  url 'http://sourceforge.net/projects/lcms/files/lcms/2.4/lcms2-2.4.tar.gz'
  homepage 'http://www.littlecms.com/'
  sha1 '9944902864283af49e4e21a1ca456db4e04ea7c2'

  depends_on 'jpeg' => :optional
  depends_on 'libtiff' => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
