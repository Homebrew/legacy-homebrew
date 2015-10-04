class Talloc < Formula
  desc "Hierarchical, reference-counted memory pool with destructors"
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.1.2.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/t/talloc/talloc_2.1.2.orig.tar.gz"
  sha256 "230d78a3fca75a15ab0f5d76d7bbaeadd3c1e695adcbb085932d227f5c31838d"

  bottle do
    cellar :any
    sha256 "ffc598494174e6ce3cd1a8bc5e1a54cc6232120d732a4be793b6440765450116" => :el_capitan
    sha256 "09562c643230ee89b534b0db792cb2e3285d2b09a24a3a3e66076bcd073d4ad9" => :yosemite
    sha256 "394a7de53648e3a0a31af88618aa28390639dfc1422b4263c707dc0f5d273533" => :mavericks
    sha256 "9f40baa58c9df7ef375e8451ac021cba5cced8e686a5093d5f786b39674f2a9d" => :mountain_lion
  end

  conflicts_with "samba", :because => "both install `include/talloc.h`"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-rpath",
                          "--without-gettext",
                          "--disable-python"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <talloc.h>
      int main()
      {
        int ret;
        TALLOC_CTX *tmp_ctx = talloc_new(NULL);
        if (tmp_ctx == NULL) {
          ret = 1;
          goto done;
        }
        ret = 0;
      done:
        talloc_free(tmp_ctx);
        return ret;
      }
    EOS
    system ENV.cc, "-I#{include}", "-L#{lib}", "-ltalloc", "test.c", "-o", "test"
    system testpath/"test"
  end
end
