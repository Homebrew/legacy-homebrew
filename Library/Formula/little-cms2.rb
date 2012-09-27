require 'formula'

class LittleCms2 < Formula
  url 'http://sourceforge.net/projects/lcms/files/lcms/2.3/lcms2-2.3.tar.gz'
  homepage 'http://www.littlecms.com/'
  sha1 '67d5fabda2f5777ca8387766539b9c871d993133'

  depends_on 'jpeg' => :optional
  depends_on 'libtiff' => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
