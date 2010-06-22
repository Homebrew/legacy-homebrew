require 'formula'

class Unittest <Formula
  @url='http://unittest.red-bean.com/tar/unittest-0.50-62.tar.gz'
  @homepage='http://unittest.red-bean.com/'
  @md5='6eaa2823620c2e21fc745bd8da6a26b2'

  def install
    fails_with_llvm
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
