require 'formula'

class Parallel < Formula
  homepage 'http://savannah.gnu.org/projects/parallel/'
  url 'http://ftpmirror.gnu.org/parallel/parallel-20140222.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20140222.tar.bz2'
  sha256 '7e74cc72d350cfab0bfff64c1910773030e74ca0ee5f60e528cae425d283637d'

  conflicts_with 'moreutils',
    :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
