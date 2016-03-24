class Qdbm < Formula
  desc "Library of routines for managing a database"
  homepage "http://fallabs.com/qdbm"
  url "http://fallabs.com/qdbm/qdbm-1.8.78.tar.gz"
  sha256 "b466fe730d751e4bfc5900d1f37b0fb955f2826ac456e70012785e012cdcb73e"

  bottle do
    cellar :any
    revision 1
    sha256 "6fd80b953a53cdf048bf686d2ac3620deda19a022a10a1e7cbd7aea073bf9b6a" => :el_capitan
    sha256 "4784d30c880c089dcef588c7d91d537269404a4917c9b2b1ef8b5123a727cee1" => :yosemite
    sha256 "bf5c5c1a087e22f9f06d29e2e139e55f6866ac1826ef725733d108ace6cf4d67" => :mavericks
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
