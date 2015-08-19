class Cunit < Formula
  desc "Lightweight unit testing framework for C"
  homepage "http://cunit.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/cunit/CUnit/2.1-3/CUnit-2.1-3.tar.bz2"
  sha256 "f5b29137f845bb08b77ec60584fdb728b4e58f1023e6f249a464efa49a40f214"

  bottle do
    cellar :any
    sha1 "7f56e9cd7509523403a9989ebdb4bde202c9b834" => :yosemite
    sha1 "ecad657c01ac67e6da01d3d6de086f11ad9c06cf" => :mavericks
    sha1 "a4fa117d4d1ba31a42b41645324919defea49f16" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    inreplace "bootstrap", "libtoolize", "glibtoolize"
    system "sh", "bootstrap", prefix
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdio.h>
      #include <string.h>
      #include "CUnit/Basic.h"

      int noop(void) { return 0; }

      void test42(void) { CU_ASSERT(42 == 42); }

      int main(void)
      {
         CU_pSuite pSuite = NULL;
         if (CUE_SUCCESS != CU_initialize_registry())
            return CU_get_error();
         pSuite = CU_add_suite("Suite_1", noop, noop);
         if (NULL == pSuite) {
            CU_cleanup_registry();
            return CU_get_error();
         }
         if (NULL == CU_add_test(pSuite, "test of 42", test42)) {
            CU_cleanup_registry();
            return CU_get_error();
         }
         CU_basic_set_mode(CU_BRM_VERBOSE);
         CU_basic_run_tests();
         CU_cleanup_registry();
         return CU_get_error();
      }
    EOS

    system ENV.cc, "test.c", "-L#{lib}", "-lcunit", "-o", "test"
    assert_match "test of 42 ...passed", shell_output("./test")
  end
end
