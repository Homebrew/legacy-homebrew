class Latexmk < Formula
  desc "Automates the process of generating a LaTeX document."
  homepage "http://users.phys.psu.edu/~collins/software/latexmk-jcc/"
  url "http://users.phys.psu.edu/~collins/software/latexmk-jcc/latexmk-443a.zip"
  version "4.43a"
  sha256 "e410d295c0a47327b953ece5b582c294359bdf89138ef990d5621b020ff2bbe5"

  depends_on :tex

  def install
    mv "latexmk.pl", "latexmk"
    bin.install "latexmk"
  end

  test do
    system "#{bin}/latexmk", "-help"
  end
end
