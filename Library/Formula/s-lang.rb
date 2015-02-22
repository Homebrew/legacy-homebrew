class SLang < Formula
  homepage "http://www.jedsoft.org/slang/"
  url "http://www.jedsoft.org/releases/slang/slang-2.3.0.tar.bz2"
  mirror "http://pkgs.fedoraproject.org/repo/pkgs/slang/slang-2.3.0.tar.bz2/3bcc790460d52db1316c20395b7ac2f1/slang-2.3.0.tar.bz2"
  sha1 "6e26e90307d4569e5feef195648c0858ba27f7ac"

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
