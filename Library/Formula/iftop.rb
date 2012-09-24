require 'formula'

class Iftop < Formula
  url 'http://www.ex-parrot.com/pdw/iftop/download/iftop-1.0pre2.tar.gz'
  homepage 'http://www.ex-parrot.com/~pdw/iftop/'
  version '1.0pre2'
  sha1 'd4dc473f8263192334da6289b69e102a4ae7df9e'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
