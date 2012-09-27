require 'formula'

class Glpk < Formula
  url 'http://ftpmirror.gnu.org/glpk/glpk-4.47.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/glpk/glpk-4.47.tar.gz'
  homepage 'http://www.gnu.org/software/glpk/'
  sha1 '35e16d3167389b6bc75eb51b4b48590db59f789c'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
