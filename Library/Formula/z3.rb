class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.4.1.tar.gz"
  sha256 "50967cca12c5c6e1612d0ccf8b6ebf5f99840a783d6cf5216336a2b59c37c0ce"
  head "https://github.com/Z3Prover/z3.git"

  option "without-python", "Build without python 2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on :python3 => :optional

  if build.without?("python3") && build.without?("python")
    odie "z3: --with-python3 must be specified when using --without-python"
  end

  bottle do
    cellar :any
    sha256 "ea169ccefdbebdd17213b4fab603dce2029b03bde0b62fa98920cbaf431d4771" => :el_capitan
    sha256 "e8f726245f283d43efe68f2516ebf1fc62fd2ab486a850befc0c388ef9f5c1ed" => :yosemite
    sha256 "2c67f6d604e3b478bac87e223891f3252a8f29a048564a91a8ea57f6c3b9a8ba" => :mavericks
  end

  def install
    inreplace "scripts/mk_util.py", "dist-packages", "site-packages"

    Language::Python.each_python(build) do |python, version|
      system python, "scripts/mk_make.py", "--prefix=#{prefix}", "--staticlib"
      cd "build" do
        system "make"
        system "make", "install"
      end
    end

    pkgshare.install "examples"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lz3",
           pkgshare/"examples/c/test_capi.c", "-o", testpath/"test"
    system "./test"
  end
end
