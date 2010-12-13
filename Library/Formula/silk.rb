require 'formula'

class Silk <Formula
  url 'http://tools.netsa.cert.org/releases/silk-2.4.0.tar.gz'
  homepage 'http://tools.netsa.cert.org/silk/'
  md5 '3c12579712e2f49b07e56055a209d20a'

  depends_on 'pkg-config' => :build
  depends_on 'glib'
  depends_on 'libfixbuf'
  depends_on 'yaf'

  def install
    fails_with_llvm "Undefined symbols during compile"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--enable-ipv6",
                          "--enable-data-rootdir=#{var}/silk"
    system "make"
    system "make install"

    (var+"silk").mkpath
  end
end
