require 'formula'

class Xspringies <Formula
  url 'http://www.cs.rutgers.edu/~decarlo/software/xspringies-1.12.tar.Z'
  homepage 'http://www.cs.rutgers.edu/~decarlo/software.html'
  md5 '14b14916471874e9d0569ab5f4e8d492'
  version '1.12'

  def install
    inreplace 'Makefile.std', 'LIBS = -lm -lX11', 'LIBS = -L/usr/X11/lib -lm -lX11'
    inreplace 'Makefile.std', 'mkdirhier', 'mkdir -p'
    system "make -f Makefile.std DDIR=#{prefix}/ install"
  end
end
