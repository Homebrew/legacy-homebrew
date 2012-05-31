require 'formula'

class Yaf < Formula
  homepage 'http://tools.netsa.cert.org/yaf/'
  url 'http://tools.netsa.cert.org/releases/yaf-2.1.2.tar.gz'
  md5 '77ab8927db0cb28965d70dbceb65a1f4'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libfixbuf'

  fails_with :llvm do
    cause "Undefined symbols during compile"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
