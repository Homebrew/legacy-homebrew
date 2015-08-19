class GooglePerftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://code.google.com/p/gperftools/"
  url "https://googledrive.com/host/0B6NtGsLhIcf7MWxMMF9JdTN3UVk/gperftools-2.4.tar.gz"
  sha256 "982a37226eb42f40714e26b8076815d5ea677a422fb52ff8bfca3704d9c30a2d"

  bottle do
    cellar :any
    sha1 "182f0141d4d35e0d674ac65e92942beddef19579" => :yosemite
    sha1 "c07c8decd4323cfcc8bd96a6c94076a044ab9b6d" => :mavericks
    sha1 "5511c9311f6882df6fc70433818647fb77d59188" => :mountain_lion
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
