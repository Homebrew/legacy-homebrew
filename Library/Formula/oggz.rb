require 'formula'

class Oggz <Formula
  url 'http://downloads.xiph.org/releases/liboggz/liboggz-1.0.0.tar.gz'
  md5 '57359f6f0824b3e9bad85b49a6418514'
  homepage 'http://www.xiph.org/oggz/'

  depends_on 'pkg-config'
  depends_on 'libogg'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
