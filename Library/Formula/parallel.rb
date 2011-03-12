require 'formula'

class Parallel <Formula
  url 'http://ftp.gnu.org/gnu/parallel/parallel-20110205.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/parallel/'
  md5 '4a8484fd4e11fd2fee63ee763f22786c'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
