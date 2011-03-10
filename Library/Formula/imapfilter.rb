require 'formula'

class Imapfilter < Formula
  url 'http://imapfilter.hellug.gr/source/imapfilter-2.2.2.tar.bz2'
  homepage 'http://imapfilter.hellug.gr/'
  md5 '09c6ffb085a5a244dc9f3e798259f341'

  depends_on 'lua'
  depends_on 'pcre'

  def install
    system "./configure", "-p", prefix, "-m", man
    system "make"
    system "make install"
  end
end
