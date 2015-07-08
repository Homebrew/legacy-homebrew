class Syntaxerl < Formula
  homepage "https://github.com/ten0s/syntaxerl"
  desc "Syntax checker for Erlang code and config files"
  url "https://github.com/ten0s/syntaxerl/archive/0.8.0.tar.gz"
  sha256 "4c5a6390a7d28869bf44cc831ae59cb69480a8481853de8dd59672b7cf5bff7b"

  bottle do
    cellar :any
    sha256 "91e1dbffa26469b1738f3f7ed5229e1295a2f743c34160f1883b544675c080d2" => :yosemite
    sha256 "52967a2ac507a5c7be860c58d0636c4a890f4c6fa0b95bf0bebb533bcf595f39" => :mavericks
    sha256 "8416da42bea9d0701e0fa0a9f83865f16a0ba732a0168e646878fbe032af0dc7" => :mountain_lion
  end

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
