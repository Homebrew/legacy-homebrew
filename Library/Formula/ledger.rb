class Ledger < Formula
  desc "Command-line, double-entry accounting tool"
  homepage "http://ledger-cli.org"
  url "https://github.com/ledger/ledger/archive/v3.1.tar.gz"
  sha256 "eeb5d260729834923fc94822bcc54ca3080c434f81466a3f5dc4274b357ce694"
  head "https://github.com/ledger/ledger.git"
  revision 1

  bottle do
    sha256 "a9caafb67ee6b9bef882d7dff8e24747f3997a84bacb82b456b96c5c6448e899" => :yosemite
    sha256 "7c396585b474187340429297f151435a545c0ab0509f094461599f338eb8d045" => :mavericks
    sha256 "a47cc33ddd2ef9df9921d1ad333eac68e791e32dad86b497c9abbe8bc707a5b2" => :mountain_lion
  end

  resource "utfcpp" do
    url "https://downloads.sourceforge.net/project/utfcpp/utf8cpp_2x/Release%202.3.4/utf8_v2_3_4.zip"
    sha256 "3373cebb25d88c662a2b960c4d585daf9ae7b396031ecd786e7bb31b15d010ef"
  end

  deprecated_option "debug" => "with-debug"

  option "with-debug", "Build with debugging symbols enabled"
  option "with-docs", "Build HTML documentation"
  option "without-python", "Build without python support"

  depends_on "cmake" => :build
  depends_on "gmp"
  depends_on "mpfr"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard

  boost_opts = []
  boost_opts << "c++11" if MacOS.version < "10.9"
  depends_on "boost" => boost_opts
  depends_on "boost-python" => boost_opts if build.with? "python"

  stable do
    # library shouldn't explicitly link a python framework
    # https://github.com/ledger/ledger/pull/415
    patch do
      url "https://github.com/ledger/ledger/commit/5f08e27.diff"
      sha256 "064b0e64d211224455511cd7b82736bb26e444c3af3b64936bec1501ed14c547"
    end

    # but the executable should
    # https://github.com/ledger/ledger/pull/416
    patch :DATA

    # boost 1.58 compatibility
    # https://github.com/ledger/ledger/pull/417
    patch do
      url "https://github.com/ledger/ledger/commit/2e02e0.diff"
      sha256 "c1438cbf989995dd0b4bfa426578a8763544f28788ae76f9ff5d23f1b8b17add"
    end
  end

  needs :cxx11

  def install
    ENV.cxx11

    (buildpath/"lib/utfcpp").install resource("utfcpp") unless build.head?
    resource("utfcpp").stage { include.install Dir["source/*"] }

    flavor = (build.with? "debug") ? "debug" : "opt"

    args = %W[
      --jobs=#{ENV.make_jobs}
      --output=build
      --prefix=#{prefix}
      --boost=#{Formula["boost"].opt_prefix}
    ]

    args << "--python" if build.with? "python"

    args += %w[-- -DBUILD_DOCS=1]
    args << "-DBUILD_WEB_DOCS=1" if build.with? "docs"

    system "./acprep", flavor, "make", *args
    system "./acprep", flavor, "make", "doc", *args
    system "./acprep", flavor, "make", "install", *args
    (share+"ledger/examples").install Dir["test/input/*.dat"]
    (share+"ledger").install "contrib"
    (share+"ledger").install "python/demo.py" if build.with? "python"
    (share/"emacs/site-lisp/ledger").install Dir["lisp/*.el", "lisp/*.elc"]
  end

  test do
    balance = testpath/"output"
    system bin/"ledger",
      "--args-only",
      "--file", share/"ledger/examples/sample.dat",
      "--output", balance,
      "balance", "--collapse", "equity"
    assert_equal "          $-2,500.00  Equity", balance.read.chomp
    assert_equal 0, $?.exitstatus

    if build.with? "python"
      system "python", "#{share}/ledger/demo.py"
    end
  end
end
__END__
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index a368d37..570a659 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -273,6 +273,9 @@ if (BUILD_LIBRARY)

   add_executable(ledger main.cc global.cc)
   target_link_libraries(ledger libledger)
+  if (APPLE AND HAVE_BOOST_PYTHON)
+    target_link_libraries(ledger ${PYTHON_LIBRARIES})
+  endif()

   install(TARGETS libledger DESTINATION ${CMAKE_INSTALL_LIBDIR})
   install(FILES ${LEDGER_INCLUDES}
