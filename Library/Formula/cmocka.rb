class Cmocka < Formula
  desc "Unit testing framework for C"
  homepage "https://cmocka.org/"
  url "https://cmocka.org/files/1.0/cmocka-1.0.1.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/c/cmocka/cmocka_1.0.1.orig.tar.xz"
  sha256 "b36050d7a1224296803d216cba1a9d4c58c31bf308b2d6d6649d61aa5a36753b"

  bottle do
    cellar :any
    sha256 "33765424588cf149679e394842f6132dbb003913e774bc30d0115294952c3cad" => :yosemite
    sha256 "28ea3d6de51e920dae544f9b4f36288a04f1ee6215dd34f833c6e98bc43de0f9" => :mavericks
    sha256 "544f9a2bd42b2a868322cc9942afb191733260bb33e8a2731a53311b6c538d7d" => :mountain_lion
  end

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
