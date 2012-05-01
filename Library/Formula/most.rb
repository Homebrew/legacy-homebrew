require 'formula'

class Most < Formula
  url 'ftp://space.mit.edu/pub/davis/most/most-5.0.0a.tar.bz2'
  homepage 'http://www.jedsoft.org/most/'
  md5 '4c42abfc8d3ace1b0e0062ea021a5917'
  head 'git://git.jedsoft.org/git/most.git'

  depends_on 's-lang'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-slang=#{HOMEBREW_PREFIX}",
                          "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
