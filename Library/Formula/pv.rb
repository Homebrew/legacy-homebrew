require 'formula'

class Pv <Formula
  url 'http://pipeviewer.googlecode.com/files/pv-1.1.4.tar.bz2'
  homepage 'http://www.ivarch.com/programs/pv.shtml'
  md5 '63033e090d61a040407bfd043aeb6d27'

  aka 'pipeviewer'

  def install
    fails_with_llvm
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-nls"
    system "make install"
  end
end
