require 'formula'

class SLang <Formula
  url 'ftp://space.mit.edu/pub/davis/slang/v2.2/slang-2.2.3.tar.bz2'
  homepage 'http://www.jedsoft.org/slang/'
  md5 '17e1864de999ae9535a9f7350a010427'

  depends_on 'pcre' => :optional
  depends_on 'oniguruma' => :optional

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-png=/usr/X11R6"
    ENV.j1
    system "make"
    system "make install"
  end
end
