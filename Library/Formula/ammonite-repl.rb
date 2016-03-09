class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/archive/0.5.6.tar.gz"
  sha256 "c131a984aa101b927e34a84832b85f8e9f54c1d4a5a1f2e45d18d26a3c6122cb"

  bottle do
    cellar :any_skip_relocation
    sha256 "260453fa12dd1e61d6c4d5674a57b1be7bb421c0bf44a53039c4b9d2bfcf2083" => :el_capitan
    sha256 "f98cd77971727ace504470aa5c0fa0ea4b1a3dd5b2b5684fbc15a33af6719506" => :yosemite
    sha256 "d7a89c8db3953dc3aae0dbcd7f5fd3d53070aa2fc92a6ffd8d9e259510bf9a53" => :mavericks
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
