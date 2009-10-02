require 'brewkit'

class Jasper <Formula
  url 'http://www.ece.uvic.ca/~mdadams/jasper/software/jasper-1.900.1.zip'
  homepage 'http://www.ece.uvic.ca/~mdadams/jasper/'
  md5 'a342b2b4495b3e1394e161eb5d85d754'

  depends_on 'jpeg'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-trackinga",
                          "--enable-shared"
    system "make install"
  end
end
