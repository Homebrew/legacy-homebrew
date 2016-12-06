require 'formula'

class Chadwick <Formula
  url 'http://cdnetworks-us-2.dl.sourceforge.net/project/chadwick/chadwick-0.5/0.5.3/chadwick-0.5.3.tar.gz'
  homepage 'http://chadwick.sourceforge.net/doc/index.html'
  md5 'd8941a0bc0d075e9eb612cf7744657bf'

  def install
    system "./configure"
    system "make"
    system "make install"
  end
end
