class Ledger < Formula
  homepage "http://ledger-cli.org"
  url "https://github.com/ledger/ledger/archive/v3.1.tar.gz"
  sha1 "549aa375d4802e9dd4fd153c45ab64d8ede94afc"
  head "https://github.com/ledger/ledger.git"

  bottle do
    revision 3
    sha256 "0fb1aefa3cf1e52cce8f7153818bab704a7bf29197e5691def5398e272a1a972" => :yosemite
    sha256 "a9d67f14335ff833b389d3b5b57110af7ab268e51e960caf4cd21d2a745ea441" => :mavericks
    sha256 "2ad8d5e6e038d5a7761b389e33455c5113b4e6387754e48aaaa55e69e7b2a7f9" => :mountain_lion
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
    # don't explicitly link a python framework
    # https://github.com/ledger/ledger/pull/415
    patch do
      url "https://github.com/ledger/ledger/commit/5f08e27.diff"
      sha256 "064b0e64d211224455511cd7b82736bb26e444c3af3b64936bec1501ed14c547"
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
