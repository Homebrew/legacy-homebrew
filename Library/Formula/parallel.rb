require 'formula'

class Parallel < Formula
  homepage 'http://savannah.gnu.org/projects/parallel/'
  url 'http://ftpmirror.gnu.org/parallel/parallel-20130822.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20130822.tar.bz2'
  sha256 'b857c744479fe19137bdbd240dd6205882b31be924c9ce0a0f4566e67e8d25d9'

  conflicts_with 'moreutils',
    :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
