require 'formula'

class Faac < Formula
  url 'http://downloads.sourceforge.net/project/faac/faac-src/faac-1.28/faac-1.28.tar.gz'
  md5 '80763728d392c7d789cde25614c878f6'
  homepage 'http://www.audiocoding.com/faac.html'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
