require 'formula'

class Parallel <Formula
  url 'http://ftp.gnu.org/gnu/parallel/parallel-20101222.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/parallel/'
  md5 '7d531b835fa7ba2975a3d3cdf13aae4c'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
