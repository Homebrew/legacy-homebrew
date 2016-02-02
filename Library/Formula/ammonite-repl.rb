class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/archive/0.5.3.tar.gz"
  sha256 "e55215d68820e8be176c86942cf082b5efbbad39ed61a89af97c99557ef61fe8"

  bottle do
    cellar :any_skip_relocation
    sha256 "b9933e8aa1915ae0daffca393779d6a21e675c9c639652a50717211f053f48ae" => :el_capitan
    sha256 "0ba8b816a6184d82cd25574318da6150e7e19559e82effa39f9e2c314400aa66" => :yosemite
    sha256 "249e79ee6096295ab85f554a4ee38a1a31b108c437b9bb31df057d5e96adbcc5" => :mavericks
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
