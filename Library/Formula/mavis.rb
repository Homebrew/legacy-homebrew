require "formula"

class Mavis < Formula
  homepage "http://mavis.kasoki.de"
  url "https://github.com/kasoki/mavis/archive/v0.1.1.tar.gz"
  sha1 "d3a92fb0fac0fdbb78f1e05386b82039ee9fca57"

  depends_on "premake" => :build

  def install
    system "premake4", "gmake"
    system "make"

    lib.install "libmavis.dylib"
    include.install "mavis/include/mavis"
  end

  test do
    (testpath / "test.cpp").write <<-EOS.undent
      #include <mavis/mavis.hpp>

      mavis::test test_test() {
        return mavis_assert_true(true);
      }

      int main() {
        auto test_unit = mavis::create_test_unit("chuck testa");

        test_unit.add_test(test_test);

        test_unit.run_tests();

        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-std=c++11", "-lmavis"
  end
end
