require 'formula'

class Pcre <Formula
  url 'ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.02.tar.bz2'
  homepage 'http://www.pcre.org/'
  md5 '27948c1b5f5c1eabc23cba1ebe4c316f'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-utf8",
                          "--enable-unicode-properties",
                          "--enable-pcregrep-libz",
                          "--enable-pcregrep-libbz2"
    system "make install"
  end
end
