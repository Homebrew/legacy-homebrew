class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://code.google.com/p/gperftools/"
  url "https://googledrive.com/host/0B6NtGsLhIcf7MWxMMF9JdTN3UVk/gperftools-2.4.tar.gz"
  sha256 "982a37226eb42f40714e26b8076815d5ea677a422fb52ff8bfca3704d9c30a2d"

  bottle do
    cellar :any
    revision 1
    sha256 "ed20c4f8ac1be86d15eb5d634a42da8e087acbdf235db4b7d103f405f1af17c2" => :el_capitan
    sha256 "a3e20ad0d06dff8197c8b940e50e30d3e5e31ac7370b041d5f375c5865380311" => :yosemite
    sha256 "a8129731beef1d0ec4f026b1c1da67ef8bb715c094fe2c5e384bcc139bc0e46d" => :mavericks
    sha256 "e699b94174325abdf47246370a3169760633a180a01f50e453ad651f1125e80c" => :mountain_lion
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
