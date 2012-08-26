require 'formula'

class SLang < Formula
  homepage 'http://www.jedsoft.org/slang/'
  url 'ftp://space.mit.edu/pub/davis/slang/v2.2/slang-2.2.4.tar.bz2'
  sha1 '34e68a993888d0ae2ebc7bc31b40bc894813a7e2'

  depends_on :libpng # For png-module.so
  depends_on 'pcre' => :optional
  depends_on 'oniguruma' => :optional

  def install
    pnglib = MacOS::X11.installed? ? MacOS::X11.lib : HOMEBREW_PREFIX/'lib'
    pnginc = MacOS::X11.installed? ? MacOS::X11.include : HOMEBREW_PREFIX/'include'

    system "./configure", "--prefix=#{prefix}",
<<<<<<< HEAD
                          "--with-pnglib=#{MacOS::XQuartz.lib}",
                          "--with-pnginc=#{MacOS::XQuartz.include}"
=======
                          "--with-pnglib=#{pnglib}",
                          "--with-pnginc=#{pnginc}"
>>>>>>> 0dba76a6beda38e9e5357faaf3339408dcea0879
    ENV.j1
    system "make"
    system "make install"
  end
end
