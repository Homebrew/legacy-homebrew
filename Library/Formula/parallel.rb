require 'formula'

class Parallel <Formula
  url 'http://ftp.gnu.org/gnu/parallel/parallel-20110125.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/parallel/'
  md5 'db67c116fc07288c09daf8fb6f3cb0bf'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
