require 'formula'

class Htmldoc <Formula
  url 'http://ftp.easysw.com/pub/htmldoc/1.8.27/htmldoc-1.8.27-source.tar.bz2'
  homepage 'http://www.htmldoc.org'
  md5 '35589e7b8fe9c54e11be87cd5aec4dcc'
  
  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
