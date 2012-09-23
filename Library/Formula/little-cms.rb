require 'formula'

class LittleCms < Formula
  url 'http://sourceforge.net/projects/lcms/files/lcms/1.19/lcms-1.19.tar.gz'
  homepage 'http://www.littlecms.com/'
  sha1 'd5b075ccffc0068015f74f78e4bc39138bcfe2d4'

  depends_on 'jpeg' => :optional
  depends_on 'libtiff' => :optional

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make install"
  end
end
