require 'formula'

class Parallel < Formula
  homepage 'http://savannah.gnu.org/projects/parallel/'
  url 'http://ftpmirror.gnu.org/parallel/parallel-20130222.tar.bz2'
  mirror 'http://ftp.gnu.org/gnu/parallel/parallel-20130222.tar.bz2'
  sha256 'ebd3a66ff96bfcb00812c08a856bdf0f02e3de8864613283917775f5551e20ef'

  conflicts_with 'moreutils',
    :because => "both install a 'parallel' executable."

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
