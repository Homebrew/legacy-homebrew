require 'formula'

class SLang < Formula
  homepage 'http://www.jedsoft.org/slang/'
  url 'ftp://space.mit.edu/pub/davis/slang/v2.2/slang-2.2.4.tar.bz2'
  mirror 'http://pkgs.fedoraproject.org/repo/pkgs/slang/slang-2.2.4.tar.bz2/7fcfd447e378f07dd0c0bae671fe6487/slang-2.2.4.tar.bz2'
  sha1 '34e68a993888d0ae2ebc7bc31b40bc894813a7e2'

  bottle do
    sha1 "312ff6dd9da406831aeeaeee312317f759e0b4a2" => :mavericks
    sha1 "69df7a58e958882a2a10d8b4f7e170e2de06809b" => :mountain_lion
    sha1 "7181f19055794dc55e27ad29d89e5d872d5e7e40" => :lion
  end

  depends_on :libpng
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
