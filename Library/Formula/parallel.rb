require 'formula'

class Parallel < Formula
  homepage 'http://savannah.gnu.org/projects/parallel/'
  url 'http://ftpmirror.gnu.org/parallel/parallel-20140322.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20140322.tar.bz2'
  sha256 'b4690319856f9a4cbb73cdd498d358666412d1fbc8848f1e83edf4d5d62d69fe'

  conflicts_with 'moreutils',
    :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
