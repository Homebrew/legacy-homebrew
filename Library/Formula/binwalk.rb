require 'formula'

class Binwalk < Formula
  homepage 'http://code.google.com/p/binwalk/'
  url 'http://binwalk.googlecode.com/files/binwalk-0.4.5.tar.gz'
  sha1 'cdc7918cada78b8d84c61a38d9c50a21704adfba'

  depends_on 'libmagic'

  def install
    cd "src" do
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make install"
    end
  end
end
