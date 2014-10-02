require 'formula'

class Ntl < Formula
  homepage 'http://www.shoup.net/ntl'
  url 'http://www.shoup.net/ntl/ntl-6.2.1.tar.gz'
  sha1 '3b9ab3bedb0b2e9b5ee322d60745be5caf1c743f'

  def install
    cd "src" do
      system "./configure", "PREFIX=#{prefix}"
      system "make"
      system "make check"
      system "make install"
    end
  end
end
