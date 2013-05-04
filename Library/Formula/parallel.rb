require 'formula'

class Parallel < Formula
  homepage 'http://savannah.gnu.org/projects/parallel/'
  url 'http://ftpmirror.gnu.org/parallel/parallel-20130422.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20130422.tar.bz2'
  sha256 '3090bb1ce3d56fe8c844a6ba4faa2ada69554f50c2ec46bdcd5d382d9a61cf2b'

  conflicts_with 'moreutils',
    :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
