require 'formula'

class Parallel < Formula
  homepage 'http://savannah.gnu.org/projects/parallel/'
  url 'http://ftpmirror.gnu.org/parallel/parallel-20131122.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20131122.tar.bz2'
  sha256 'ef5e0af618cd71c2a2d96ab3aa800ca44e6fab830092176db4b3468b747e29d0'

  conflicts_with 'moreutils',
    :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
