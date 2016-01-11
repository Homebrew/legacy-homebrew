class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/archive/0.5.2.tar.gz"
  sha256 "78d496e8ad7b8e98aa7005c8160e99c326c8a9b6dba82bd2ae2a171577965237"

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
    bin.install "repl/target/scala-2.11/ammonite-repl-0.5.2-2.11.7" => "amm"
  end

  test do
    ENV.java_cache

    assert_equal "hello world!", shell_output("#{bin}/amm -c 'print(\"hello world!\")'")
  end
end
