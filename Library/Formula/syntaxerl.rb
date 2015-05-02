class Syntaxerl < Formula
  homepage "https://github.com/ten0s/syntaxerl"
  desc "Syntax-checker for Erlang code and config files"
  url "https://github.com/ten0s/syntaxerl/archive/0.8.0.tar.gz"
  sha256 "4c5a6390a7d28869bf44cc831ae59cb69480a8481853de8dd59672b7cf5bff7b"

  depends_on "erlang"

  def install
    system "make"
    bin.install "syntaxerl"
  end

  test do
    (testpath/"app.config").write "[{app,[{arg1,1},{arg2,2}]}]."
    assert_equal "", shell_output("#{bin}/syntaxerl #{testpath}/app.config")

    (testpath/"invalid.config").write "]["
    assert_match /invalid.config:1: syntax error before: '\]'/, shell_output("#{bin}/syntaxerl #{testpath}/invalid.config")
  end
end
