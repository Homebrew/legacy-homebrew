require 'formula'

class Parallel < Formula
  homepage 'http://savannah.gnu.org/projects/parallel/'
  url 'http://ftpmirror.gnu.org/parallel/parallel-20140122.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20140122.tar.bz2'
  sha256 'b18339bba65f9b2e287ec934d05c12e8103c2c83bc7f9b3c06f6648ecf15c79f'

  conflicts_with 'moreutils',
    :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
