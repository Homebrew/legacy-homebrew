require 'formula'

class SLang < Formula
  homepage 'http://www.jedsoft.org/slang/'
  url 'ftp://space.mit.edu/pub/davis/slang/v2.2/slang-2.2.4.tar.bz2'
  sha1 '34e68a993888d0ae2ebc7bc31b40bc894813a7e2'

  depends_on :libpng # For png-module.so
  depends_on 'pcre' => :optional
  depends_on 'oniguruma' => :optional

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-pnglib=#{MacOS::X11.lib}",
                          "--with-pnginc=#{MacOS::X11.include}"
    ENV.j1
    system "make"
    system "make install"
  end
end
