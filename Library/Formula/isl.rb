class Isl < Formula
  desc "Integer Set Library for the polyhedral model"
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
    revision 3
    sha256 "c74aad1f83bd7e5f431ef5f14e5168a3de361d5358634e572ab9f33c49bf1e02" => :el_capitan
    sha256 "8f2930559c015c477a094e67f2f70aff8ef0fb37296432e95921569fa9080db9" => :yosemite
    sha256 "835d04dc9d6be86f7480b31824522ece83895ec0ed78314caf900c4bfd5611fa" => :mavericks
    sha256 "19f797f8031bd373bb13a61ceefd9d74ee74cca0af1790617020f8a951ae8ce2" => :mountain_lion
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
