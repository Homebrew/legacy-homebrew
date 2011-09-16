require 'formula'

class Fltk < Formula
  homepage 'http://www.fltk.org/'

  unless ARGV.flag? '--devel'
    url 'http://ftp2.easysw.com/pub/fltk/1.3.0/fltk-1.3.0-source.tar.gz'
    md5 '44d5d7ba06afdd36ea17da6b4b703ca3'
  else
    url 'http://ftp.easysw.com/pub/fltk/snapshots/fltk-1.3.x-r9013.tar.bz2'
    md5 '9c5eb9eb8642be56cb68e7c5b1c98611'
  end

  depends_on 'jpeg'

  def install
    ENV.libpng
    system "autoconf" if ARGV.flag? '--devel'

    system "./configure", "--prefix=#{prefix}", "--enable-threads"
    system "make install"
  end
end
