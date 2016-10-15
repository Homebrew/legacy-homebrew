class Cfdg < Formula
  homepage "http://www.contextfreeart.org/"
  url "http://www.contextfreeart.org/download/ContextFreeSource3.0.8.tgz"
  sha1 "bbd90c74fd0e66cb071c342da52ad016e023da2b"

  depends_on "bison" => :build
  depends_on "libpng"

  def install
    system "make"
    bin.install "cfdg"
  end

  test do
    (testpath/"test.cfdg").write <<-EOS.undent
    startshape SPIKE

    CF::Symmetry = CF::Dihedral, 6

    shape SPIKE
    rule {
      SQUARE []
      SPIKE [y 0.95 s 0.97]
    }
    rule 0.03 {
      SQUARE []
      SPIKE [r 60]
      SPIKE [r -60]
      SPIKE [y 0.95 s 0.97]
    }
    EOS
    system "cfdg", "-s", "700", "test.cfdg", "test.cfdg.png"
  end
end
