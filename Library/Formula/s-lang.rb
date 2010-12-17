require 'formula'

class SLang <Formula
  url 'ftp://space.mit.edu/pub/davis/slang/v2.2/slang-2.2.3.tar.bz2'
  homepage 'http://www.s-lang.org/'
  md5 '17e1864de999ae9535a9f7350a010427'

  depends_on 'pcre' => :optional
  depends_on 'oniguruma' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-png=/usr/X11R6"
    system "make"
    ENV.deparallelize
    system "make install"
  end
end
