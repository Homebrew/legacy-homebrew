class Wdt < Formula
  desc "Transfer data as fast as possible over multiple TCP paths."
  homepage "https://github.com/facebook/wdt"

  stable do
    url "https://github.com/facebook/wdt/archive/v1.26.1603040.tar.gz"
    sha256 "b0fffdd12478ef74de50852b9c356352dae5f7ccee22dbca91a88afc6c5b6fee"

    resource "folly" do
      url "https://github.com/facebook/folly/archive/v0.57.0.tar.gz"
      sha256 "92fc421e5ea4283e3c515d6062cb1b7ef21965621544f4f85a2251455e034e4b"
    end

    patch :DATA
  end

  head do
    url "https://github.com/facebook/wdt.git"

    resource "folly" do
      url "https://github.com/facebook/folly.git"
    end
  end

  depends_on "cmake" => :build
  depends_on "gflags" => :build
  depends_on "glog" => :build
  depends_on "double-conversion" => :build
  depends_on "openssl"
  depends_on "folly"
  depends_on "boost"

  needs :cxx11

  def install
    ENV.cxx11
    ENV.libcxx if ENV.compiler == :clang

    args = %W[
      -DOPENSSL_ROOT_DIR=#{Formula["openssl"].opt_prefix}
      -DFOLLY_SOURCE_DIR=#{buildpath}/folly
    ]

    (buildpath/"folly").install resource("folly")

    mktemp do
      mkdir "wdt"
      cp_r Dir["#{buildpath}/."], "wdt"

      system "cmake", buildpath, *(std_cmake_args + args)
      system "make"
      system "make", "install"
    end
  end

  test do
    system "#{bin}/wdt", "--version"

    (testpath/"test.cpp").write <<-EOS.undent
      #include <wdt/Wdt.h>
      using namespace facebook::wdt;
      int main() {
        Wdt::initializeWdt("test");
        return 0;
      }
    EOS

    ENV.cxx11

    system *(ENV.cxx.split + %W[test.cpp -L#{lib} -o test
                                -I#{Formula["openssl"].opt_include}
                                -L#{HOMEBREW_PREFIX}/lib
                                -lboost_system -lwdt])
    system "./test"
  end
end

__END__
diff --git a/CMakeLists.txt b/CMakeLists.txt
index c4190c9..b5aaf9c 100644
--- a/CMakeLists.txt
+++ b/CMakeLists.txt
@@ -68,6 +68,7 @@ set (FOLLY_CPP_SRC
 "${FOLLY_SOURCE_DIR}/folly/Conv.cpp"
 "${FOLLY_SOURCE_DIR}/folly/Demangle.cpp"
 "${FOLLY_SOURCE_DIR}/folly/Checksum.cpp"
+"${FOLLY_SOURCE_DIR}/folly/Malloc.cpp"
 )

 # WDT's library proper - comes from: ls -1 *.cpp | grep -iv test
