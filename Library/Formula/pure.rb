require 'formula'

class PureDocs < Formula
  url 'http://pure-lang.googlecode.com/files/pure-docs-0.56.tar.gz'
  sha1 '8feaf83269d4f7f1287268c3c0c6fa83669c8d80'
end

class Pure < Formula
  homepage 'http://code.google.com/p/pure-lang/'
  url 'http://pure-lang.googlecode.com/files/pure-0.56.tar.gz'
  sha1 '224fa4057a5ec931a97ba5f938f96a4a9ab3bf1a'

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
