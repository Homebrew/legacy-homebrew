class Cmocka < Formula
  homepage "https://cmocka.org/"
  url "https://cmocka.org/files/1.0/cmocka-1.0.0.tar.xz"
  sha1 "c1b6bdab164b2d54c26edacef9b9308e4de154f9"

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", "-DUNIT_TESTING=On", *std_cmake_args
      system "make"
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <stdarg.h>
      #include <stddef.h>
      #include <setjmp.h>
      #include <cmocka.h>

      static void null_test_success(void **state) {
        (void) state; /* unused */
      }

      int main(void) {
        const struct CMUnitTest tests[] = {
            cmocka_unit_test(null_test_success),
        };
        return cmocka_run_group_tests(tests, NULL, NULL);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcmocka", "-o", "test"
    system "./test"
  end
end
