require 'formula'

class Parallel <Formula
  url 'ftp://ftp.gnu.org/gnu/parallel/parallel-20101122.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/parallel/'
  md5 '8cec9d765c323385da730a750f17baf8'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
