require 'formula'

class Sdcc < Formula
  homepage 'http://sdcc.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/sdcc/sdcc/3.0.0/sdcc-src-3.0.0.tar.bz2'
  sha1 '5f50f3841d58c10432bc4352e06a3f1b1f339ec1'

  depends_on 'gputils'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-avr-port",
                          "--enable-xa51-port"
    system "make all"
    system "make install"
  end
end
