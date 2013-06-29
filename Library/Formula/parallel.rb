require 'formula'

class Parallel < Formula
  homepage 'http://savannah.gnu.org/projects/parallel/'
  url 'http://ftpmirror.gnu.org/parallel/parallel-20130522.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20130522.tar.bz2'
  sha256 'e9ea6fa2644e8504a85a518edb246783f2ccace58f21d101712b28bf781d7d2b'

  conflicts_with 'moreutils',
    :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
