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
    revision 1
    sha256 "f7673e8d731bf2a1518adaf667c4122b433170796c9c866fd779f4b12c62bb27" => :el_capitan
    sha256 "20deb35825a2ebfc76bdb959080781944967ed72d3f48591ba8df0fc5bae7912" => :yosemite
    sha256 "81c89c70da771d0d1faae38657e43849f741cb68486afbf50a21be76bf612799" => :mavericks
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
