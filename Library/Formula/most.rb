require 'formula'

class Most < Formula
  url 'ftp://space.mit.edu/pub/davis/most/most-5.0.0a.tar.bz2'
  homepage 'http://www.jedsoft.org/most/'
  sha1 'de9fe30ae405c32f8424f10571839519a25f3043'
  head 'git://git.jedsoft.org/git/most.git'

  depends_on 's-lang'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-slang=#{HOMEBREW_PREFIX}",
                          "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
