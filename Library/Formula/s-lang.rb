class SLang < Formula
  homepage "http://www.jedsoft.org/slang/"
  url "ftp://space.mit.edu/pub/davis/slang/v2.2/slang-2.2.4.tar.bz2"
  mirror "http://pkgs.fedoraproject.org/repo/pkgs/slang/slang-2.2.4.tar.bz2/7fcfd447e378f07dd0c0bae671fe6487/slang-2.2.4.tar.bz2"
  sha1 "34e68a993888d0ae2ebc7bc31b40bc894813a7e2"
  revision 1

  bottle do
    revision 3
    sha1 "ffec100fcd2ca2e2bdbe96617c0638dcfd926ad6" => :yosemite
    sha1 "f4e661e6b8db584640352dd5c5642cc5d6da0ee7" => :mavericks
    sha1 "05b71621028660b6eb7c07f5585a8dff0b1e27f3" => :mountain_lion
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

  test do
    assert_equal "Hello World!", shell_output("#{bin}/slsh -e 'message(\"Hello World!\");'").strip
  end
end
