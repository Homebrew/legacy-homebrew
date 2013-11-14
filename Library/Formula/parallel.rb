require 'formula'

class Parallel < Formula
  homepage 'http://savannah.gnu.org/projects/parallel/'
  url 'http://ftpmirror.gnu.org/parallel/parallel-20131022.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20131022.tar.bz2'
  sha256 '93280c7a03c18b07685157af36f2dfc82bbc59828acbdfe86ed27171a442b6f9'

  conflicts_with 'moreutils',
    :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
