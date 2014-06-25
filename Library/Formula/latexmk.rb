require "formula"

class Latexmk < Formula
  homepage "http://users.phys.psu.edu/~collins/software/latexmk-jcc/"
  url "http://users.phys.psu.edu/~collins/software/latexmk-jcc/latexmk-440.zip"
  sha1 "55b85c4a86f6136ad9ab300b7717c4c0e32082a5"
  version "4.40"

  depends_on :tex

  def install
    bin.install "latexmk.pl" => "latexmk"
    man1.install "latexmk.1"
  end

  test do
    File.open("test.tex", "w") do |f|
      f.write <<-EOF.undent
        \\documentclass[]{article}
        \\begin{document}
        hello world!
        \\end{document}
      EOF
    end

    system "#{bin}/latexmk", "-pdf", "test.tex"

    File.exists? "test.pdf"
  end
end
