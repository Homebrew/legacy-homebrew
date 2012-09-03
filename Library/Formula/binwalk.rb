require 'formula'

class Binwalk < Formula
  homepage 'http://code.google.com/p/binwalk/'
  url 'http://binwalk.googlecode.com/files/binwalk-0.4.2.tar.gz'
  sha1 '160ad2f4dd7f37628a4fade5d16c0c9996174ab2'

  depends_on 'libmagic'

  def install
    cd "src" do
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make install"
    end
  end
end
