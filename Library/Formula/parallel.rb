require 'formula'

class Parallel <Formula
  url 'http://ftp.gnu.org/gnu/parallel/parallel-20101202.tar.bz2'
  homepage 'http://savannah.gnu.org/projects/parallel/'
  md5 '66d5c7825a05a1c641555868c9de955a'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
