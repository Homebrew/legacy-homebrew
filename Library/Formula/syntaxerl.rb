class Syntaxerl < Formula
  homepage "https://github.com/ten0s/syntaxerl"
  desc "Syntax checker for Erlang code and config files"
  url "https://github.com/ten0s/syntaxerl/archive/0.10.0.tar.gz"
  sha256 "ee2748ecfbcdc62a6cc4181032be9c6de232f5603ac019f9d14d6861a3c5df8a"

  bottle do
    cellar :any_skip_relocation
    sha256 "76dbad50161a18864c891857eed2800ba11057b7e8d25866cd2273d656057887" => :el_capitan
    sha256 "3354fa14b4179431e38ce4f5f65153a30a262822d08c30b387cadd0f94708c36" => :yosemite
    sha256 "85a9db8ff434298e3fa40a4429e298b9aa2205bdefbebe1ac2b83b8b949d7c67" => :mavericks
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
