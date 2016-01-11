class Isl < Formula
  desc "Integer Set Library for the polyhedral model"
  homepage "http://isl.gforge.inria.fr"
  # Note: Always use tarball instead of git tag for stable version.
  #
  # Currently isl detects its version using source code directory name
  # and update isl_version() function accordingly.  All other names will
  # result in isl_version() function returning "UNKNOWN" and hence break
  # package detection.
  url "http://isl.gforge.inria.fr/isl-0.15.tar.bz2"
  mirror "ftp://gcc.gnu.org//pub/gcc/infrastructure/isl-0.15.tar.bz2"
  sha256 "8ceebbf4d9a81afa2b4449113cee4b7cb14a687d7a549a963deb5e2a41458b6b"

  bottle do
    cellar :any
    sha256 "8fd8215540c6d44494400fbc964ffabfccfdf806fb4a1de8c8c302f06d998f0f" => :el_capitan
    sha256 "b370c775e2e670df7cab1375833722c72a1121e49b30d780746878945f7ef9c2" => :yosemite
    sha256 "13a5858f8a27b63d6613f5f29c44bfc1c9c6b95d625e3fbd1ff71acf17557476" => :mavericks
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
