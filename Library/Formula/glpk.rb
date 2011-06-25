require 'formula'

class Glpk < Formula
  url 'http://ftp.gnu.org/gnu/glpk/glpk-4.44.tar.gz'
  homepage 'http://www.gnu.org/software/glpk/'
  md5 'f2ac7013bc0420d730d052e7ba24bdb1'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
