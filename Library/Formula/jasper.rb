require 'formula'

class Jasper <Formula
  url 'http://www.ece.uvic.ca/~mdadams/jasper/software/jasper-1.900.1.zip'
  homepage 'http://www.ece.uvic.ca/~mdadams/jasper/'
  md5 'a342b2b4495b3e1394e161eb5d85d754'

  depends_on 'jpeg'

  def install
    fails_with_llvm "Undefined symbols when linking", :build => "2326"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--enable-shared",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
