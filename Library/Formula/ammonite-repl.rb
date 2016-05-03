class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/archive/0.5.7.tar.gz"
  sha256 "0f347aacb9c706199db54af88f8ada67f6183cc090d4df4e94d931b07d0a"

  bottle do
    cellar :any_skip_relocation
    sha256 "02fab559ad7837181378cf622476049808ba3eb02af2dacdf3ab651e6cb4d103" => :el_capitan
    sha256 "95d030040a6fd69368b052f53c25cb8ec6ac0c84e422fe4a8f765d9d36459334" => :yosemite
    sha256 "40f14e8805cb7b33fb685463bc77c1ab0e1c7e8e54eb15817c604d65b7dd984b" => :mavericks
  end

  depends_on :java => "1.6+"
  depends_on "sbt" => :build

  def install
    ENV.java_cache

    system "sbt", "repl/assembly"

    bin.install "repl/target/scala-2.11/ammonite-repl-#{version}-2.11.8" => "amm"
  end

  test do
    ENV.java_cache

    assert_equal "hello world!", shell_output("#{bin}/amm -c 'print(\"hello world!\")'")
  end
end
