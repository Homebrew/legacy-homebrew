require 'formula'

class PureDocs < Formula
  url 'http://pure-lang.googlecode.com/files/pure-docs-0.55.tar.gz'
  sha1 'f16d5b7dd6bbf5294d0e1d9258421574d33d7e09'
end

class Pure < Formula
  homepage 'http://code.google.com/p/pure-lang/'
  url 'http://pure-lang.googlecode.com/files/pure-0.55.tar.gz'
  sha1 '3786b7708956fa981605d078833d638a8e4216c3'

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
