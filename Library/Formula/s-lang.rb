class SLang < Formula
  desc "Library for creating multi-platform software"
  homepage "http://www.jedsoft.org/slang/"
  url "http://www.jedsoft.org/releases/slang/slang-2.3.0.tar.bz2"
  mirror "http://pkgs.fedoraproject.org/repo/pkgs/slang/slang-2.3.0.tar.bz2/3bcc790460d52db1316c20395b7ac2f1/slang-2.3.0.tar.bz2"
  sha256 "f95224060f45e0d8212a5039b339afa5f1a94a1bb0298e796104e5b12e926129"

  bottle do
    sha256 "f6836798d838e52af2536255ed91b96e05068b7378fb93b4bd0fbfd52e04a381" => :el_capitan
    sha1 "5ee9afbf50de909d6e0a74d00b5e32162dc890e3" => :yosemite
    sha1 "48400ef87e23ca59bb65dc0ee59487e573bf2df2" => :mavericks
    sha1 "f27927f44ec63a865773b2fa9e0f7830b1089ecf" => :mountain_lion
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
