class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/archive/0.5.1.tar.gz"
  sha256 "62369fc19946304a28f2af8d4918dd91d33a8b212e0916900847b95a79cdd718"

  bottle do
    cellar :any_skip_relocation
    sha256 "22360a08a174b61dddcfee8319b39b4c587f2cf5db1042c6e5c9648ba8bc2b8b" => :el_capitan
    sha256 "0e653f4ff906a47ad24af33f20b4f177abe6182d4162a7e4c237c9cb2d1bf1a5" => :yosemite
    sha256 "faf12614b1f3beed91e89b973141aba234830276a1e00e1d8b7aeb4b60e01e47" => :mavericks
  end

  depends_on :java => "1.6+"
  depends_on "sbt" => :build

  def install
    ENV.java_cache

    system "sbt", "repl/assembly"
    bin.install "repl/target/scala-2.11/ammonite-repl-0.5.1-2.11.7" => "amm"
  end

  test do
    ENV.java_cache

    assert_equal "hello world!", shell_output("#{bin}/amm -c 'print(\"hello world!\")'")
  end
end
