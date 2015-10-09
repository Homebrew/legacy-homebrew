class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.4.0.tar.gz"
  sha256 "65b72f9eb0af50949e504b47080fb3fc95f11c435633041d9a534473f3142cba"
  head "https://github.com/Z3Prover/z3.git"
  revision 1

  def install
    inreplace "scripts/mk_util.py", "dist-packages", "site-packages"
    system "python", "scripts/mk_make.py", "--prefix=#{prefix}"

    cd "build" do
      system "make"
      system "make", "install"
    end

    pkgshare.install "examples"
  end

  test do
    system ENV.cc, "-I#{include}", "-L#{lib}", "-lz3",
           pkgshare/"examples/c/test_capi.c", "-o", testpath/"test"
    system "./test"
  end
end
