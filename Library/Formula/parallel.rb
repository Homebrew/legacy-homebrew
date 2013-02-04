require 'formula'

class Parallel < Formula
  homepage 'http://savannah.gnu.org/projects/parallel/'
  url 'http://ftpmirror.gnu.org/parallel/parallel-20130122.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20130122.tar.bz2'
  sha256 '941376a761e77011add4d1bf5c3361c098f3bed8922d226baac2897f1a65112a'

  conflicts_with 'moreutils',
    :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
