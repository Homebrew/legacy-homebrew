require 'formula'

class Ntl < Formula
  homepage 'http://www.shoup.net/ntl'
  url 'http://www.shoup.net/ntl/ntl-6.0.0.tar.gz'
  sha1 'ee71b1c6a94f34b8a3c226502a0a0c6c2d1bc3f9'

  def install
    cd "src" do
      system "./configure", "PREFIX=#{prefix}"
      system "make"
      system "make check"
      system "make install"
    end
  end
end
