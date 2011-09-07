require 'formula'

class Parallel < Formula
  url 'http://ftp.gnu.org/gnu/parallel/parallel-20110822.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/parallel/'
  md5 'ec2538f9bf32ef328bb5503c35dce8c9'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
