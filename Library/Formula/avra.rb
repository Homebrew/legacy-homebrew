require 'formula'

class Avra < Formula
  homepage 'http://avra.sourceforge.net/'
  url 'http://sourceforge.net/projects/avra/files/1.3.0/avra-1.3.0.tar.bz2'
  md5 'd5d48369ceaa004c4ca09f61f69b2c84'

  def install
    # build fails if these don't exist
    system "touch NEWS ChangeLog"
    cd "src" do
      system "./bootstrap"
      system "./configure", "--prefix=#{prefix}"
      system "make install"
    end
  end
end
