require 'formula'

class Qhull <Formula
  url 'http://www.qhull.org/download/qhull-2010.1-src.tgz'
  homepage 'http://www.qhull.org/'
  md5 'e64138470acdeb18f752a0bc2a11ceb4'

  def install
    cd "./src"
    ENV['MANDIR']=man
    system "make -e -f Makefile"
    mkdir_p man
    system "make -e -f Makefile install"
  end
end
