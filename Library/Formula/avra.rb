require 'formula'

class Avra < Formula
  url 'http://sourceforge.net/projects/avra/files/1.3.0/avra-1.3.0.tar.bz2'
  homepage 'http://avra.sourceforge.net/'
  md5 'd5d48369ceaa004c4ca09f61f69b2c84'

  def install
    # build fails if these don't exist
    system "touch NEWS ChangeLog"
    Dir.chdir "src" do
      system "./bootstrap"
      system "./configure --prefix=#{prefix}"
      system "make install"
    end
  end
end
