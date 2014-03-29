require 'formula'

class SLang < Formula
  homepage 'http://www.jedsoft.org/slang/'
  url 'ftp://space.mit.edu/pub/davis/slang/v2.2/slang-2.2.4.tar.bz2'
  mirror 'http://pkgs.fedoraproject.org/repo/pkgs/slang/slang-2.2.4.tar.bz2/7fcfd447e378f07dd0c0bae671fe6487/slang-2.2.4.tar.bz2'
  sha1 '34e68a993888d0ae2ebc7bc31b40bc894813a7e2'
  revision 1

  bottle do
    sha1 "f0c840d9a76e697fb6eb99256c6e57d0f7446ebf" => :mavericks
    sha1 "fb9f9f51c37f4622294fc3627c0f656f773ed617" => :mountain_lion
    sha1 "f905aeb8deb12e2fcabda88df1d6842212c94087" => :lion
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
