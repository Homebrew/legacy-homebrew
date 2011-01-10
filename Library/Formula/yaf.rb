require 'formula'

class Yaf <Formula
  url 'http://tools.netsa.cert.org/releases/yaf-1.3.1.tar.gz'
  homepage 'http://tools.netsa.cert.org/yaf/'
  md5 'cf7602056d8eaa157f5a53f77d193761'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libfixbuf'

  def install
    fails_with_llvm "Undefined symbols during compile"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make"
    system "make install"
  end
end
