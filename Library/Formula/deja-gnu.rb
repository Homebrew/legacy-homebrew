require 'formula'

class DejaGnu <Formula
  url 'http://mirrors.kernel.org/gnu/dejagnu/dejagnu-1.4.4.tar.gz'
  homepage 'http://www.gnu.org/software/dejagnu/'
  md5 '053f18fd5d00873de365413cab17a666'

  def install
    ENV.j1 # Or fails on Mac Pro
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
