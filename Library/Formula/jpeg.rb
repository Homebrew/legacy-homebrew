require 'formula'

class Jpeg <Formula
  url 'http://www.ijg.org/files/jpegsrc.v8a.tar.gz'
  version '8a'
  md5 '5146e68be3633c597b0d14d3ed8fa2ea'
  homepage 'http://www.ijg.org'
  
  aka :libjpeg, :libjpg

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end