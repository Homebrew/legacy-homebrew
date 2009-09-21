require 'brewkit'

class SLang <Formula
  @url='ftp://space.mit.edu/pub/davis/slang/v2.2/slang-2.2.1.tar.gz'
  @homepage='http://www.s-lang.org/'
  @md5='9a72420df2aa7b1932a195c6e5a85465'

  depends_on 'pcre' => :optional
  depends_on 'oniguruma' => :optional

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--with-png=/usr/X11R6"
    system "make"
    
    ENV.deparallelize
    system "make install"
  end
end
