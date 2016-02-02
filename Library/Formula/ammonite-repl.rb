class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/archive/0.5.3.tar.gz"
  sha256 "e55215d68820e8be176c86942cf082b5efbbad39ed61a89af97c99557ef61fe8"

  bottle do
    cellar :any_skip_relocation
    sha256 "045f72ca3f02d5d9f30e15a9ae1e5b0499d229a8384462b745a5e660c1c83e4e" => :el_capitan
    sha256 "f766cf1e3f75b02a40d1b9c8ed8b9d6c49572f9180e7dff06c89b4909cd8bde3" => :yosemite
    sha256 "532d4a8e5953e5c564e94915f8224328a680a085c51f22ccee5e1f2624a178b4" => :mavericks
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
