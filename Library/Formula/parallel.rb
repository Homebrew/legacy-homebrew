require 'formula'

class Parallel < Formula
  homepage 'http://savannah.gnu.org/projects/parallel/'
  url 'http://ftpmirror.gnu.org/parallel/parallel-20130922.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20130922.tar.bz2'
  sha256 'e8fa0e4dd06781aa90f4567493ae61233b8db6a1b35257f8d229f9efd737b909'

  conflicts_with 'moreutils',
    :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
