class Talloc < Formula
  homepage "https://talloc.samba.org/"
  url "https://www.samba.org/ftp/talloc/talloc-2.1.2.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/t/talloc/talloc_2.1.2.orig.tar.gz"
  sha256 "230d78a3fca75a15ab0f5d76d7bbaeadd3c1e695adcbb085932d227f5c31838d"

  bottle do
    cellar :any
    sha1 "95140108cb3675eedb25493d9a6ae51681b293eb" => :yosemite
    sha1 "48d9ed5b9dc8d86b9787d2911df70a4dd2ef1307" => :mavericks
    sha1 "d573466b7e520fcb1cf46fba2d7cd1314a3f1025" => :mountain_lion
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
