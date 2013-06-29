require 'formula'

class PureDocs < Formula
  url 'https://bitbucket.org/purelang/pure-lang/downloads/pure-docs-0.57.tar.gz'
  sha1 '7f2c6051b831d3de887f2182e8b29b1716ab45fd'
end

class Pure < Formula
  homepage 'http://purelang.bitbucket.org/'
  url 'https://bitbucket.org/purelang/pure-lang/downloads/pure-0.57.tar.gz'
  sha1 '5c7441993752d0e2cba74912521d6df865e5dc0b'

  depends_on 'llvm'
  depends_on 'gmp'
  depends_on 'readline'
  depends_on 'mpfr'

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-release",
                          "--without-elisp"
    system "make"
    system "make check"
    system "make install"

    PureDocs.new.brew { system "make", "prefix=#{prefix}", "install" }
  end
end
