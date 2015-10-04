class Qdbm < Formula
  desc "QDBM is a library of routines for managing a database"
  homepage "http://fallabs.com/qdbm"
  url "http://fallabs.com/qdbm/qdbm-1.8.78.tar.gz"
  sha256 "b466fe730d751e4bfc5900d1f37b0fb955f2826ac456e70012785e012cdcb73e"

  bottle do
    cellar :any
    sha256 "f972348b30472d08534cbe0fdf5044ec229849e8cc9236ecb246a59a986c7501" => :yosemite
    sha256 "deb25f34920331d4d02bc49463cff93c7741acb144988905ea05731f28c37a78" => :mavericks
    sha256 "bb386d7715c6d46281f05a6678e9fbe2b75fd514f00553584940ea5a2059ed3f" => :mountain_lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}",
                          "--enable-bzip",
                          "--enable-zlib",
                          "--enable-iconv"
    system "make", "mac"
    system "make", "check-mac"
    system "make", "install-mac"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <depot.h>
      #include <stdlib.h>
      #include <stdio.h>

      #define NAME     "mike"
      #define NUMBER   "00-12-34-56"
      #define DBNAME   "book"

      int main(void) {
        DEPOT *depot;
        char *val;

        if(!(depot = dpopen(DBNAME, DP_OWRITER | DP_OCREAT, -1))) { return 1; }
        if(!dpput(depot, NAME, -1, NUMBER, -1, DP_DOVER)) { return 1; }
        if(!(val = dpget(depot, NAME, -1, 0, -1, NULL))) { return 1; }

        printf("%s, %s\\n", NAME, val);
        free(val);

        if(!dpclose(depot)) { return 1; }

        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lqdbm", "-o", "test"
    assert_equal "mike, 00-12-34-56", shell_output("./test").chomp
  end
end
