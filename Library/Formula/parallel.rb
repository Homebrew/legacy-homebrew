require 'formula'

class Parallel < Formula
  homepage 'http://savannah.gnu.org/projects/parallel/'
  url 'http://ftpmirror.gnu.org/parallel/parallel-20121222.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20121222.tar.bz2'
  sha256 '0ce96ad4e36734baae7ce6c8d99d004810fbfdf5209d6f86d5b5fc9a92dc17f8'

  conflicts_with 'moreutils',
    :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
