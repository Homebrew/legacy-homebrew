require 'formula'

class Parallel < Formula
  url 'http://ftp.gnu.org/gnu/parallel/parallel-20110422.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/parallel/'
  md5 '3102c91feb24dba2b225e81a209af91a'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
