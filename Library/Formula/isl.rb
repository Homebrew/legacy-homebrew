class Isl < Formula
  homepage "http://freecode.com/projects/isl"
  # Note: Always use tarball instead of git tag for stable version.
  #
  # Currently isl detects its version using source code directory name
  # and update isl_version() function accordingly.  All other names will
  # result in isl_version() function returning "UNKNOWN" and hence break
  # package detection.
  url "http://isl.gforge.inria.fr/isl-0.14.1.tar.xz"
  sha256 "8882c9e36549fc757efa267706a9af733bb8d7fe3905cbfde43e17a89eea4675"

  bottle do
    cellar :any
    sha256 "338fe34f90f9528233e77903ff50a462d7a4052c65a99cabf23d85ad7b419cea" => :yosemite
    sha256 "b71266042b8f5c74134b256fe169bf533976e714bc9d4912c2781d71ed167773" => :mavericks
    sha256 "7d95fc4f1b9404f87b849eebd207818cd90ad5d0aca98763693a83876372dba9" => :mountain_lion
  end

  head do
    url "http://repo.or.cz/r/isl.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "gmp"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-gmp=system",
                          "--with-gmp-prefix=#{Formula["gmp"].opt_prefix}"
    system "make"
    system "make", "install"
    (share/"gdb/auto-load").install Dir["#{lib}/*-gdb.py"]
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <isl/ctx.h>

      int main()
      {
        isl_ctx* ctx = isl_ctx_alloc();
        isl_ctx_free(ctx);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-lisl", "-o", "test"
    system "./test"
  end
end
