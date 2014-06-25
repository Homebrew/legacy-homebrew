require 'formula'

class SLang < Formula
  homepage 'http://www.jedsoft.org/slang/'
  url 'ftp://space.mit.edu/pub/davis/slang/v2.2/slang-2.2.4.tar.bz2'
  mirror 'http://pkgs.fedoraproject.org/repo/pkgs/slang/slang-2.2.4.tar.bz2/7fcfd447e378f07dd0c0bae671fe6487/slang-2.2.4.tar.bz2'
  sha1 '34e68a993888d0ae2ebc7bc31b40bc894813a7e2'
  revision 1

  bottle do
    revision 1
    sha1 "21a69be9c04987b3f0f9fe22e5c67e1bbf35ffdf" => :mavericks
    sha1 "6419ca383eaa2841c0a1b4c8000d7ef3e4e8ce8a" => :mountain_lion
    sha1 "ba07bb45335ab72814f95b9eadace80b85e7c770" => :lion
  end

  depends_on 'libpng'
  depends_on 'pcre' => :optional
  depends_on 'oniguruma' => :optional

  def install
    png = Formula["libpng"]
    system "./configure", "--prefix=#{prefix}",
                          "--with-pnglib=#{png.lib}",
                          "--with-pnginc=#{png.include}"
    ENV.j1
    system "make"
    system "make install"
  end
end
