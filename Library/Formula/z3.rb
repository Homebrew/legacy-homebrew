class Z3 < Formula
  desc "High-performance theorem prover"
  homepage "https://github.com/Z3Prover/z3"
  url "https://github.com/Z3Prover/z3/archive/z3-4.4.0.tar.gz"
  sha256 "65b72f9eb0af50949e504b47080fb3fc95f11c435633041d9a534473f3142cba"
  head "https://github.com/Z3Prover/z3.git"
  revision 1

  bottle do
    cellar :any
    sha256 "747f0ed14c4420c2724b970612150431983938a29174db9d03aad78a824193f4" => :el_capitan
    sha256 "3490f8cd97c7d90ccf635d8296e63dbc7b3055dccac0831065b39ab08363e9f3" => :yosemite
    sha256 "ecae50a10a368e2684b7ab5d205efa58136369e4db9374fccf164fb0b8884f55" => :mavericks
  end

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
