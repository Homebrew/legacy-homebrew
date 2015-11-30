class Minisat < Formula
  desc "Boolean satisfiability (SAT) problem solver"
  homepage "http://minisat.se"
  url "https://github.com/niklasso/minisat/archive/releases/2.2.0.tar.gz"
  sha256 "3ed44da999744c0a1be269df23c3ed8731cdb83c44a4f3aa29b3d6859bb2a4da"

  bottle do
    cellar :any
    sha256 "c2537e0e2d6428e87f1ed7f502fd0fa86f3c7ee2cee58b27817f6fdd20b3a66b" => :el_capitan
    sha256 "c261e92ecf583b97b78f3e4924324d8804387b61ed3474d2d3284120e07355d6" => :yosemite
    sha256 "ce8794df1ba908e6b062fe55f2db55e9398b3c23e881da7e3cb118b645b938f0" => :mavericks
  end

  # Upstream commits to fix some declaration errors
  patch do
    url "https://github.com/niklasso/minisat/commit/9bd874980a7e5d65cecaba4edeb7127a41050ed1.patch"
    sha256 "01075c9b855a3ba5296da8522f3569446c35af25e51759d610b39292b5f97872"
  end

  patch do
    url "https://github.com/niklasso/minisat/commit/cfae87323839064832c8b3608bf595548dd1a1f3.patch"
    sha256 "5e6ff10d692067b2715033db0a9eaeec45480c138e3453fee2a5668348fb786c"
  end

  fails_with :clang do
    cause "error: friend declaration specifying a default argument must be a definition"
  end

  def install
    ENV["MROOT"] = buildpath
    system "make", "-C", "simp", "r"
    bin.install "simp/minisat_release" => "minisat"
  end

  test do
    dimacs = <<-EOS.undent
      p cnf 3 2
      1 -3 0
      2 3 -1 0
    EOS

    assert_match(/^SATISFIABLE$/, pipe_output("#{bin}/minisat", dimacs, 10))
  end
end
