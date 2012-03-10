require 'formula'

class Corkscrew < Formula
  url 'http://www.agroman.net/corkscrew/corkscrew-2.0.tar.gz'
  homepage 'http://www.agroman.net/corkscrew/'
  md5 '35df77e7f0e59c0ec4f80313be52c10a'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--host=apple"
    system "make install"
  end
end
