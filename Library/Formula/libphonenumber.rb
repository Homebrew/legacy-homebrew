class Libphonenumber < Formula
  desc "C++ Phone Number library by Google"
  homepage "https://github.com/googlei18n/libphonenumber"
  url "https://github.com/googlei18n/libphonenumber/archive/libphonenumber-7.2.3.tar.gz"
  sha256 "9f93615b23d8a12a42099d8113a8d6304278bee4d0ef09fd366188a206aacd46"

  bottle do
    cellar :any
    sha256 "a366e801dc9a3b5d7cd2683213c7559ad432be08b4d7bcad39a8f69f6ba158e0" => :el_capitan
    sha256 "6c9dcdd382bf07f98b421f820026cdbdafae13c2642c07dd818d83e60f8c16f3" => :yosemite
    sha256 "9d2c3989b760e1fc000970af88e07289229ed7905cf99a9f78d940e55a60533e" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on :java => "1.7+"
  depends_on "icu4c"
  depends_on "protobuf"
  depends_on "boost"
  depends_on "re2"

  resource "gtest" do
    url "https://googletest.googlecode.com/files/gtest-1.7.0.zip"
    sha256 "247ca18dd83f53deb1328be17e4b1be31514cedfc1e3424f672bf11fd7e0d60d"
  end

  # This patch is from
  # https://github.com/googlei18n/libphonenumber/issues/822#issuecomment-163038243
  #
  # In OSX there's an issue with compilation not linking references correctly.
  # This patch fixes that.
  patch :DATA

  def install
    (buildpath/"gtest").install resource("gtest")

    cd "gtest" do
      system "cmake", ".", *std_cmake_args
      system "make"
    end

    args = std_cmake_args
    args << "-DGTEST_INCLUDE_DIR:PATH=#{(buildpath/"gtest/include")}"
    args << "-DGTEST_LIB:PATH=#{buildpath/"gtest/libgtest.a"}"
    args << "-DGTEST_SOURCE_DIR:PATH=#{buildpath/"gtest/src"}"

    system "cmake", "cpp", *args
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <phonenumbers/phonenumberutil.h>
      #include <phonenumbers/phonenumber.pb.h>
      #include <iostream>
      #include <string>

      using namespace i18n::phonenumbers;

      int main() {
        PhoneNumberUtil *phone_util_ = PhoneNumberUtil::GetInstance();
        PhoneNumber test_number;
        string formatted_number;
        test_number.set_country_code(1);
        test_number.set_national_number(6502530000ULL);
        phone_util_->Format(test_number, PhoneNumberUtil::E164, &formatted_number);
        if (formatted_number == "+16502530000") {
          return 0;
        } else {
          return 1;
        }
      }
    EOS
    system ENV.cxx, "test.cpp", "-L#{lib}", "-lphonenumber", "-o", "test"
    system "./test"
  end
end
__END__
diff --git a/cpp/CMakeLists.txt b/cpp/CMakeLists.txt
index 3539b94..9a1def9 100644
--- a/cpp/CMakeLists.txt
+++ b/cpp/CMakeLists.txt
@@ -415,7 +415,7 @@ if (${BUILD_GEOCODER} STREQUAL "ON")
   # Note that the subset of base/ on which the geocoder relies is implemented
   # on top of Boost header-only libraries (e.g. scoped_ptr.hpp).
   target_link_libraries (geocoding ${LIBRARY_DEPS})
-  target_link_libraries (geocoding-shared ${LIBRARY_DEPS})
+  target_link_libraries (geocoding-shared phonenumber-shared ${LIBRARY_DEPS})
 endif ()

 # Build a specific library for testing purposes.
