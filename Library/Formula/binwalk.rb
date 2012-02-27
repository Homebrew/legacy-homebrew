require 'formula'

class Binwalk < Formula
  homepage 'http://code.google.com/p/binwalk/'
  url 'http://binwalk.googlecode.com/files/binwalk-0.4.2.tar.gz'
  md5 '9559d114760f6a58825004b4379fd95f'

  depends_on 'libmagic'

  def install
    cd "src" do
      system "./configure", "--prefix=#{prefix}"
      system "make"
      system "make install"
    end
  end
end
