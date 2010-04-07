require 'formula'

class Fltk <Formula
  url 'http://ftp2.easysw.com/pub/fltk/1.1.10/fltk-1.1.10-source.tar.gz'
  homepage 'http://www.fltk.org/'
  md5 'e6378a76ca1ef073bcb092df1ef3ba55'

  def install
    system "./configure", "--prefix=#{prefix}", "--enable-threads"
    system "make install"
  end
end
