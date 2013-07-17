require 'formula'

class LittleCms2 < Formula
  homepage 'http://www.littlecms.com/'
  url 'http://downloads.sourceforge.net/project/lcms/lcms/2.5/lcms2-2.5.tar.gz'
  sha1 'bab3470471fc7756c5fbe71be9a3c7d677d2ee7b'

  depends_on 'jpeg' => :optional
  depends_on 'libtiff' => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
