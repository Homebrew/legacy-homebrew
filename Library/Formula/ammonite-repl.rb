class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/archive/0.4.8.tar.gz"
  sha256 "5ba76b6dad8e4397e5163112fd6ae2c4a35ea52a0e612b6f8ac774e896d9aa87"

  depends_on :java => "1.6+"
  depends_on "sbt" => :build

  def install
    ENV["_JAVA_OPTIONS"] = "-Duser.home=#{ENV["HOME"]}"
    system "sbt", "repl/assembly"
    bin.install "repl/target/scala-2.11/ammonite-repl-0.4.8-2.11.7" => "amm"
  end

  test do
    ENV["_JAVA_OPTIONS"] = "-Duser.home=#{ENV["HOME"]}"
    assert_equal "hello world!", shell_output("#{bin}/amm -c 'print(\"hello world!\")'")
  end
end
