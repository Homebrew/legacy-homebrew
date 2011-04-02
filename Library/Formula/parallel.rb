require 'formula'

class Parallel < Formula
  url 'http://ftp.gnu.org/gnu/parallel/parallel-20110322.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/parallel/'
  md5 '2e8eafdc2fa21d99bfc22aac01e245ef'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
