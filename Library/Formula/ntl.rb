require 'formula'

class Ntl < Formula
  homepage 'http://www.shoup.net/ntl'
  url 'http://www.shoup.net/ntl/ntl-5.5.2.tar.gz'
  sha1 'b45e3858f7f351afeb7fbb831b256befc4892b06'

  def install
    cd "src" do
      system "./configure", "PREFIX=#{prefix}"
      system "make"
      system "make check"
      system "make install"
    end
  end
end
