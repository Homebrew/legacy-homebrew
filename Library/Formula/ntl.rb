require 'formula'

class Ntl < Formula
  homepage 'http://www.shoup.net/ntl'
  url 'http://www.shoup.net/ntl/ntl-6.1.0.tar.gz'
  sha1 '91fa69e71ee964dc94c107eb762a97425776ac2c'

  def install
    cd "src" do
      system "./configure", "PREFIX=#{prefix}"
      system "make"
      system "make check"
      system "make install"
    end
  end
end
