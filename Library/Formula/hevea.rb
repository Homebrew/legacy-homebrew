class Hevea < Formula
  desc "LaTeX-to-HTML translator"
  homepage "http://hevea.inria.fr/"
  url "http://hevea.inria.fr/old/hevea-2.23.tar.gz"
  sha256 "db8ec1459cace8f008387dbcf745ba56917d44ff62c7bdba843da250109137b9"

  bottle do
    sha256 "d6f5a5ce7cd70c14fe1f9355ac8e7af264b093304c4f8488e5df190f5b6e434d" => :yosemite
    sha256 "53300a1adc2db5cc8b80fbc3395564e8c65d35fdce8c7e20dcac42563962efdf" => :mavericks
    sha256 "1777a109ad7bf3693bd3cb0c09ec99846fbb73611e705eba4a7a48cf195c7ce4" => :mountain_lion
  end

  depends_on "ocaml"
  depends_on "ghostscript" => :optional

  def install
    ENV["PREFIX"] = prefix
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.tex").write <<-EOS.undent
      \\documentclass{article}
      \\begin{document}
      \\end{document}
    EOS
    system "#{bin}/hevea", "test.tex"
  end
end
