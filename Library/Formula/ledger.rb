require "formula"

class Ledger < Formula
  homepage "http://ledger-cli.org"
  revision 1

  stable do
    url "https://github.com/ledger/ledger/archive/v3.0.3.tar.gz"
    sha1 "b65c2dc78f366fc3c2db9e2b7900b727b91f4656"

    # boost 1.56 compatibility
    # https://groups.google.com/forum/#!topic/ledger-cli/9HwEJcD0My4
    patch do
      url "https://github.com/ledger/ledger/commit/d5592ea1e325131d4a7abf5e98f67fcb5cf22287.diff"
      sha1 "1225b4586f74ef71df8a575b1a868dd2a46a4cf7"
    end

    resource "utfcpp" do
      url "http://downloads.sourceforge.net/project/utfcpp/utf8cpp_2x/Release%202.3.4/utf8_v2_3_4.zip"
      sha1 "638910adb69e4336f5a69c338abeeea88e9211ca"
    end
  end

  bottle do
    sha1 "36c4723851c09f91042856c75f6f2e1d700fed0a" => :mavericks
    sha1 "deeca5a306aafc785369dc431f85ae1dd883e242" => :mountain_lion
  end

  head "https://github.com/ledger/ledger.git", :branch => "master"

  option "debug", "Build with debugging symbols enabled"
  option "with-docs", "Build HTML documentation"

  depends_on "cmake" => :build
  depends_on "ninja" => :build
  depends_on "mpfr"
  depends_on "gmp"
  depends_on :python => :optional

  boost_opts = []
  boost_opts << "c++11" if MacOS.version < "10.9"
  depends_on "boost" => boost_opts
  depends_on "boost-python" => boost_opts if build.with? "python"

  needs :cxx11

  def install
    ENV.cxx11

    (buildpath/"lib/utfcpp").install resource("utfcpp") unless build.head?

    flavor = build.include?("debug") ? "debug" : "opt"

    opts = %W[-- -DBUILD_DOCS=1]
    args = %W[
      --ninja --jobs=#{ENV.make_jobs}
      --output=build
      --prefix=#{prefix}
      --boost=#{Formula["boost"].opt_prefix}
    ]

    if build.with? "docs"
      opts << "-DBUILD_WEB_DOCS=1"
    end

    if build.with? "python"
      # Per #25118, CMake does a poor job of detecting a brewed Python.
      # We need to tell CMake explicitly where our default python lives.
      # Inspired by
      # https://github.com/Homebrew/homebrew/blob/51d054c/Library/Formula/opencv.rb
      args << "--python"
      python_prefix = `python-config --prefix`.strip
      opts << "-DPYTHON_LIBRARY=#{python_prefix}/Python"
      opts << "-DPYTHON_INCLUDE_DIR=#{python_prefix}/Headers"
    end

    args += opts

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
