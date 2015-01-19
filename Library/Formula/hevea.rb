require "formula"

class Hevea < Formula
  homepage "http://hevea.inria.fr/"
  url "http://hevea.inria.fr/distri/hevea-2.21.tar.gz"
  sha1 "37a13c587f008d4376a7245c43beb52d567828dd"

  bottle do
    sha1 "2daa0f13092e445e793fa56fa2cd81ea6a075be8" => :yosemite
    sha1 "3d9169aa9c0390541e12c69dd953944258bd0c71" => :mavericks
    sha1 "634a57604d5d4e3c9f69cf32f2c2135575683158" => :mountain_lion
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
