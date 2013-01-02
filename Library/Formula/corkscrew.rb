require 'formula'

class Corkscrew < Formula
  url 'http://www.agroman.net/corkscrew/corkscrew-2.0.tar.gz'
  homepage 'http://www.agroman.net/corkscrew/'
  sha1 '8bdb4c0dc71048136c721c33229b9bf795230b32'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--host=apple"
    system "make install"
  end
end
