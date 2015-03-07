class Hevea < Formula
  homepage "http://hevea.inria.fr/"
  url "http://hevea.inria.fr/distri/hevea-2.22.tar.gz"
  sha1 "16ddc99402940fe06b89723f7c4e5cb0c646d55f"

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
