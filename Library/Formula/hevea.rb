class Hevea < Formula
  homepage "http://hevea.inria.fr/"
  url "http://hevea.inria.fr/old/hevea-2.23.tar.gz"
  sha256 "db8ec1459cace8f008387dbcf745ba56917d44ff62c7bdba843da250109137b9"

  bottle do
    sha1 "bfac35ec39ad56dc6ff8d4c5d64ce9491dfc7baa" => :yosemite
    sha1 "534bc9f95fc528965a7477f753764b4fa3f06c91" => :mavericks
    sha1 "2d3bddd0021cd337d427105da4cb486cdbcad0c0" => :mountain_lion
  end

  depends_on "objective-caml"
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
