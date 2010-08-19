require 'formula'

class Silk <Formula
  url 'http://tools.netsa.cert.org/releases/silk-2.3.1.tar.gz'
  homepage 'http://tools.netsa.cert.org/silk/'
  md5 'f49ca6da333e5d579347af858e6a1b83'

  depends_on 'glib'
  depends_on 'libfixbuf'
  depends_on 'yaf'

  def install
    fails_with_llvm "Please see http://github.com/mxcl/homebrew/issues/issue/2215 for details."

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
