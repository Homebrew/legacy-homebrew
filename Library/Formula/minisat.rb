class Minisat < Formula
  desc "Boolean satisfiability (SAT) problem solver"
  homepage "http://minisat.se"
  url "https://github.com/niklasso/minisat/archive/releases/2.2.0.tar.gz"
  sha256 "3ed44da999744c0a1be269df23c3ed8731cdb83c44a4f3aa29b3d6859bb2a4da"

  bottle do
    cellar :any
    revision 1
    sha256 "d895e637af42fc0a6673d13e3e97c6a0f1e6fad62af1d814c98023135762737b" => :el_capitan
    sha256 "4d8f920ddf46061ddd5cbe7196bf9c19651e8fcc7740f3d7b8679f8cc1323a73" => :yosemite
    sha256 "ea128681692834733f758f52ec1b3d87b347d5db7d1c8849fe17bdf09b1e6152" => :mavericks
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
