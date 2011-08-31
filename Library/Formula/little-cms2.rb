require 'formula'

class LittleCms2 < Formula
  url 'http://sourceforge.net/projects/lcms/files/lcms/2.2/lcms2-2.2.tar.gz'
  homepage 'http://www.littlecms.com/'
  md5 'aaf33c7c25675e6163189ba488ae20f5'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make install"
  end
end
