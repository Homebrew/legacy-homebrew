require 'formula'

class Sdcc <Formula
  url 'http://downloads.sourceforge.net/project/sdcc/sdcc/3.0.0/sdcc-src-3.0.0.tar.bz2'
  homepage 'http://sdcc.sourceforge.net/'
  md5 '20fbd49a3421e09fe65577c45524c89e'

  depends_on 'gputils'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-avr-port",
                          "--enable-xa51-port"
    system "make all"
    system "make install"
  end
end
