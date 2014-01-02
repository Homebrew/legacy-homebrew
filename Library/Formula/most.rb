require 'formula'

class Most < Formula
  homepage 'http://www.jedsoft.org/most/'
  url 'ftp://space.mit.edu/pub/davis/most/most-5.0.0a.tar.bz2'
  sha1 'de9fe30ae405c32f8424f10571839519a25f3043'

  head 'git://git.jedsoft.org/git/most.git'

  depends_on 's-lang'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-slang=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end
