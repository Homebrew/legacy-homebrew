class GooglePerftools < Formula
  homepage "https://code.google.com/p/gperftools/"
  url "https://googledrive.com/host/0B6NtGsLhIcf7MWxMMF9JdTN3UVk/gperftools-2.4.tar.gz"
  sha1 "13b904d0d1f220e43e4495f3403ee280c6da26ea"

  bottle do
    cellar :any
    sha1 "8449da34214f2a095d8f41c3d63b0d0832e5e8e8" => :yosemite
    sha1 "87000f9e996ad5c6f14c4489df7152740c6a0464" => :mavericks
    sha1 "a518d03fe9773c34d337a81023afae873e2abced" => :mountain_lion
  end

  fails_with :llvm do
    build 2326
    cause "Segfault during linking"
  end

  def install
    ENV.append_to_cflags "-D_XOPEN_SOURCE"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <assert.h>
      #include <gperftools/tcmalloc.h>

      int main()
      {
        void *p1 = tc_malloc(10);
        assert(p1 != NULL);

        tc_free(p1);

        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-ltcmalloc", "-o", "test"
    system "./test"
  end
end
