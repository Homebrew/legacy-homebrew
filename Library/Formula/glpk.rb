require 'formula'

class Glpk < Formula
  url 'http://ftpmirror.gnu.org/glpk/glpk-4.47.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/glpk/glpk-4.47.tar.gz'
  homepage 'http://www.gnu.org/software/glpk/'
  md5 '8653bf20c1f7db96b9ed369a8598a1ce'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
