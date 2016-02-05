class SLang < Formula
  desc "Library for creating multi-platform software"
  homepage "http://www.jedsoft.org/slang/"
  url "http://www.jedsoft.org/releases/slang/slang-2.3.0.tar.bz2"
  mirror "http://pkgs.fedoraproject.org/repo/pkgs/slang/slang-2.3.0.tar.bz2/3bcc790460d52db1316c20395b7ac2f1/slang-2.3.0.tar.bz2"
  sha256 "f95224060f45e0d8212a5039b339afa5f1a94a1bb0298e796104e5b12e926129"

  bottle do
    sha256 "f6836798d838e52af2536255ed91b96e05068b7378fb93b4bd0fbfd52e04a381" => :el_capitan
    sha256 "52fba342bc32cf218d575154b655a95bcd0e3e1dc1e1ea8e98e78455abf1ec68" => :yosemite
    sha256 "bc5d35bdfbfa639e3b6403b25a36a49c1dca66cd85ad25adedcc9b67db9873e2" => :mavericks
    sha256 "751b0127d64c72f502a2c197c625d0a505325c993fb39d1bf6dbdc4f9bb515c8" => :mountain_lion
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
