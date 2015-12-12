class Googletest < Formula
  desc "Google's C++ test framework"
  homepage "https://github.com/google/googletest"
  url "https://github.com/google/googletest/archive/ddb8012eb48bc203aa93dcc2b22c1db516302b29.tar.gz"
  sha256 "f32d85be16fb33f325dbb1c12ea2a0dd5317f728e7d831aedfa55a27b351e971"

  depends_on "cmake" => :build

  def install
    Dir.chdir "googletest/make"
    system "cmake", "..", *std_cmake_args
    system "make"

    include.install "../include/gtest"
    lib.install "libgtest.a"
    lib.install "libgtest_main.a"
  end

  test do
    (testpath/"sample_test.cpp").write <<-EOS.undent
        #include "gtest/gtest.h"

        int squared(const int nIn)
        {
            return nIn * nIn;
        }

        TEST(SquaredTest, BasicTest) {
            EXPECT_EQ(1, squared(1));
            EXPECT_EQ(4, squared(2));
            EXPECT_EQ(9, squared(3));
            EXPECT_EQ(16, squared(4));
            EXPECT_EQ(16, squared(-4));
            EXPECT_EQ(9, squared(-3));
            EXPECT_EQ(4, squared(-2));
            EXPECT_EQ(1, squared(-1));
        }
    EOS
    system ENV.cxx, "-o", "sample_test", "sample_test.cpp", "-lgtest", "-lgtest_main"
    exec "./sample_test"
  end
end
