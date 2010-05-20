require 'formula'

class Pure < Formula
  url 'http://pure-lang.googlecode.com/files/pure-0.43.tar.gz'
  homepage 'http://code.google.com/p/pure-lang/'
  md5 'f15b77eb6bb15e78c69e94a4ac1d9bd9'

  depends_on 'llvm'
  depends_on 'gmp'
  depends_on 'readline'

  def install
    system "./configure", "--enable-release", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
