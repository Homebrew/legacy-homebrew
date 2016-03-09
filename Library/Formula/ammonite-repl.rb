class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/archive/0.5.6.tar.gz"
  sha256 "c131a984aa101b927e34a84832b85f8e9f54c1d4a5a1f2e45d18d26a3c6122cb"

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

    bin.install "repl/target/scala-2.11/ammonite-repl-#{version}-2.11.7" => "amm"
  end

  test do
    ENV.java_cache

    assert_equal "hello world!", shell_output("#{bin}/amm -c 'print(\"hello world!\")'")
  end
end
