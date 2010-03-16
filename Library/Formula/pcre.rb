require 'formula'

class Pcre <Formula
  url 'ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.01.tar.bz2'
  homepage 'http://www.pcre.org/'
  md5 '413be1c23dabe91f637fb3770f640006'

  def install
    configure_args = [
      "--prefix=#{prefix}",
      "--disable-debug",
      "--disable-dependency-tracking",
      "--enable-utf8",
      "--enable-unicode-properties",
      "--enable-pcregrep-libz",
      "--enable-pcregrep-libbz2",
    ]

    system "./configure", *configure_args
    system "make install"
  end
end
