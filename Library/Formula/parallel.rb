require 'formula'

class Parallel < Formula
  homepage 'http://savannah.gnu.org/projects/parallel/'
  url 'http://ftpmirror.gnu.org/parallel/parallel-20120622.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20120622.tar.bz2'
  sha1 'b184a55674ce10e8bf7c65790c2806552eb79577'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
