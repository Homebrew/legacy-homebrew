require 'brewkit'

class LittleCms <Formula
  @url='http://www.littlecms.com/lcms-1.17.tar.gz'
  @homepage='http://www.littlecms.com/'
  @md5='07bdbb4cfb05d21caa58fe3d1c84ddc1'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug"
    system "make install"
  end
end
