require 'formula'

class Clamav <Formula
  url 'http://downloads.sourceforge.net/project/clamav/clamav/0.96/clamav-0.96.tar.gz'
  homepage 'http://www.clamav.net/'
  md5 '28ac7bec4cc03627a8e2d6e8647ee661'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
