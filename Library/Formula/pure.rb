require 'formula'

class Pure < Formula
  url 'http://pure-lang.googlecode.com/files/pure-0.47.tar.gz'
  homepage 'http://code.google.com/p/pure-lang/'
  sha1 'f47915ffa9fd0c7dee40f364a5751bfd4f945bf1'

  depends_on 'llvm'
  depends_on 'gmp'
  depends_on 'readline'

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-release",
                          "--without-elisp"
    system "make"
    system "make install"
    system "make install-docs"
  end
end
