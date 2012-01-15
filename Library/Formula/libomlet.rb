require 'formula'

class Libomlet < Formula
  url 'http://devel.cpl.upc.edu/freeling/downloads/7'
  homepage 'http://devel.cpl.upc.edu/freeling'
  md5 'd7e9fd27f98103a68f378ce1b34cd0d0'
  version '1.0.1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
