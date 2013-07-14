require 'formula'

class SLang < Formula
  homepage 'http://www.jedsoft.org/slang/'
  url 'ftp://space.mit.edu/pub/davis/slang/v2.2/slang-2.2.4.tar.bz2'
  mirror 'http://pkgs.fedoraproject.org/repo/pkgs/slang/slang-2.2.4.tar.bz2/7fcfd447e378f07dd0c0bae671fe6487/slang-2.2.4.tar.bz2'
  sha1 '34e68a993888d0ae2ebc7bc31b40bc894813a7e2'

  depends_on :libpng
  depends_on 'pcre' => :optional
  depends_on 'oniguruma' => :optional

  def png_prefix
    MacOS.version >= :mountain_lion ? HOMEBREW_PREFIX/"opt/libpng" : MacOS::X11.prefix
  end

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-pnglib=#{png_prefix}/lib"
                          "--with-pnginc=#{png_prefix}/include"
    ENV.j1
    system "make"
    system "make install"
  end
end
