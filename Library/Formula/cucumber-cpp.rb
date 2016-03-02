class CucumberCpp < Formula
  desc "Support for writing Cucumber step definitions in C++"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-cpp/archive/v0.3.tar.gz"
  version "0.3"
  sha256 "1c0f9949627e7528017bf00cbe49693ba9cbc3e11087f70aa33b21df93f341d6"

  depends_on "cmake" => :build
  depends_on "boost"

  def install
    system "cmake", "-DCUKE_DISABLE_GTEST=on",
                    "-DCUKE_DISABLE_CPPSPEC=on",
                    "-DCUKE_DISABLE_FUNCTIONAL=on",
                    "-DCUKE_DISABLE_BOOST_TEST=on",
                    "."
    system "cmake", "--build", "."
    include.install "include/cucumber-cpp"
    lib.install Dir["src/*.a"]
  end

  test do
    (testpath/"features/test.features").write <<-EOS.undent
      Feature: Test
      Scenario Outline: Just for test
        Given A given statement
        When A when statement
        Then A then statement
    EOS
    (testpath/"features/step_definiations/cucumber.wire").write <<-EOS.undent
      host: localhost
      port: 3902
    EOS
    (testpath/"test.cpp").write <<-EOS.undent
      #include <cucumber-cpp/defs.hpp>
      GIVEN("^A given statement$") {
      }
      WHEN("^A when statement$") {
      }
      THEN("^A then statement$") {
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lcucumber-cpp", "-o", "test", "-stdlib=libstdc++", "-std=c++11",
      "-lboost_unit_test_framework", "-lboost_regex", "-lboost_system"
    system "./test&"
    system "cucumber"
  end
end
