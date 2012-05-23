require 'formula'

class Parallel < Formula
  homepage 'http://savannah.gnu.org/projects/parallel/'
  url 'http://ftpmirror.gnu.org/parallel/parallel-20120522.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20120522.tar.bz2'
  sha1 'bc8118949f900c05ef232c6946c4ebfa779cafed'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
