require 'formula'

class Parallel < Formula
  homepage 'http://savannah.gnu.org/projects/parallel/'
  url 'http://ftpmirror.gnu.org/parallel/parallel-20130622.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20130622.tar.bz2'
  sha256 'e815e7dbffd4d91e298b3b6d0bba12a515939f8ba72ac929b7c84eaf6cf69096'

  conflicts_with 'moreutils',
    :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
