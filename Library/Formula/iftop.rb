require 'formula'

# Version is "pre-release", but is what Debian, MacPorts, etc.
# package, and upstream has not had any movement in a long time.
class Iftop < Formula
  homepage 'http://www.ex-parrot.com/~pdw/iftop/'
  url 'http://www.ex-parrot.com/pdw/iftop/download/iftop-1.0pre2.tar.gz'
  version '1.0pre2'
  sha1 'd4dc473f8263192334da6289b69e102a4ae7df9e'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end
