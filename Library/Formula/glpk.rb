require 'formula'

class Glpk < Formula
  homepage 'http://www.gnu.org/software/glpk/'
  url 'http://ftpmirror.gnu.org/glpk/glpk-4.48.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/glpk/glpk-4.48.tar.gz'
  sha1 'e00c92faa38fd5d865fa27206abbb06680bab7bb'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
