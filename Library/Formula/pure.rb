require 'formula'

class Pure < Formula
  homepage 'http://code.google.com/p/pure-lang/'
  url 'http://pure-lang.googlecode.com/files/pure-0.52.tar.gz'
  sha1 '397755f5ff78ae08111188e0bb6bdc434506730b'

  depends_on 'wget'
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
    system "make install"
    system "make install-docs"
  end
end
