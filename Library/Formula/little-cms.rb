require 'formula'

class LittleCms < Formula
  url 'http://downloads.sourceforge.net/project/lcms/lcms/2.1/lcms2-2.1.tar.gz'
  homepage 'http://www.littlecms.com/'
  md5 '08036edb115ad74456dfa20b1998b5f4'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make install"
  end
end
