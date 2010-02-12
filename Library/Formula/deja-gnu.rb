require 'formula'

class DejaGnu <Formula
  url 'http://mirrors.kernel.org/gnu/dejagnu/dejagnu-1.4.4.tar.gz'
  homepage 'http://www.gnu.org/software/dejagnu/'
  md5 '053f18fd5d00873de365413cab17a666'

  aka :dejagnu

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
