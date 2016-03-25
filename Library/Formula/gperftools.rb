class Gperftools < Formula
  desc "Multi-threaded malloc() and performance analysis tools"
  homepage "https://github.com/gperftools/gperftools"
  url "https://github.com/gperftools/gperftools/releases/download/gperftools-2.5/gperftools-2.5.tar.gz"
  sha256 "6fa2748f1acdf44d750253e160cf6e2e72571329b42e563b455bde09e9e85173"

  bottle do
    cellar :any
    sha256 "b53926eaf6db1fa5ff0e9c3412628db838a070ce57d16581f9d596a9728b47ca" => :el_capitan
    sha256 "9ce10dbc6d575ce7004ac8fa5e97d188bbd0d5dbb76e1058e5c5069e9a8e4c11" => :yosemite
    sha256 "6036aafcbbce98242174d9481b14112ec947598452f493878b1394d08e6ca275" => :mavericks
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
