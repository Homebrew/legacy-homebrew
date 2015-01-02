class SLang < Formula
  homepage "http://www.jedsoft.org/slang/"
  url "ftp://space.mit.edu/pub/davis/slang/v2.2/slang-2.2.4.tar.bz2"
  mirror "http://pkgs.fedoraproject.org/repo/pkgs/slang/slang-2.2.4.tar.bz2/7fcfd447e378f07dd0c0bae671fe6487/slang-2.2.4.tar.bz2"
  sha1 "34e68a993888d0ae2ebc7bc31b40bc894813a7e2"
  revision 1

  bottle do
    revision 2
    sha1 "dc2d2148553f6ea6ecb83f5b2997a87aac41a48e" => :yosemite
    sha1 "6498d9a823c84f48b036d1c42571b13e4a2f0a50" => :mavericks
    sha1 "274fdf93326cb429e850181a58ae13a85bfa5c4c" => :mountain_lion
  end

  depends_on "libpng"
  depends_on "pcre" => :optional
  depends_on "oniguruma" => :optional

  def install
    png = Formula["libpng"]
    system "./configure", "--prefix=#{prefix}",
                          "--with-pnglib=#{png.lib}",
                          "--with-pnginc=#{png.include}"
    ENV.j1
    system "make"
    system "make", "install"
  end
end
