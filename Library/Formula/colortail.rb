require 'formula'

class Colortail < Formula
  url 'http://joakimandersson.se/files/colortail-0.3.2.tar.gz'
  homepage 'http://joakimandersson.se/projects/colortail/'
  md5 '7363b1bc9175d5a35034b8b9f7348ada'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
