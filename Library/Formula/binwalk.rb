require 'formula'

class Binwalk < Formula
  homepage 'http://code.google.com/p/binwalk/'
  url 'http://binwalk.googlecode.com/files/binwalk-0.5.0.tar.gz'
  sha1 'e7ffb447f932fb33b5c7c9b4ca8f8ddbead7f6db'

  depends_on 'libmagic'

  def install
    cd "src" do
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make install"
    end
  end
end
