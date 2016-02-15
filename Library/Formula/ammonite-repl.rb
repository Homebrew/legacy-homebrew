class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/archive/0.5.4.tar.gz"
  sha256 "9cd2c1d19561c443a3e8eeec123461533deb98b26346b78077dc2540b26ce4c5"

  bottle do
    cellar :any_skip_relocation
    sha256 "b995e7163d3904d17ef9dc789551ce7b579fa33ec3d067ebbf81a9aa4911ba4d" => :el_capitan
    sha256 "5cd9ae338d8cce15290416984eb42fb01309a473f1d5b2de9ff11e43715d3249" => :yosemite
    sha256 "c6587102f614c545932dfae67a19aeeecd2e30608af652dce072b8048838fd64" => :mavericks
  end

  depends_on :java => "1.6+"
  depends_on "sbt" => :build

  def install
    ENV.java_cache

    system "sbt", "repl/assembly"

    # Ammonite REPL 0.5.4 incorrectly generates an executable with version 0.5.3 in the name
    # see: https://github.com/lihaoyi/Ammonite/blob/0.5.4/project/Constants.scala

    # Please use the derived version instead of an explicit version for the next release:
    # bin.install "repl/target/scala-2.11/ammonite-repl-#{version}-2.11.7" => "amm"
    bin.install "repl/target/scala-2.11/ammonite-repl-0.5.3-2.11.7" => "amm"

  end

  test do
    ENV.java_cache

    assert_equal "hello world!", shell_output("#{bin}/amm -c 'print(\"hello world!\")'")
  end
end
