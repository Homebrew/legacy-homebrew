class AmmoniteRepl < Formula
  desc "Ammonite is a cleanroom re-implementation of the Scala REPL"
  homepage "https://lihaoyi.github.io/Ammonite/#Ammonite-REPL"
  url "https://github.com/lihaoyi/Ammonite/archive/0.5.0.tar.gz"
  sha256 "302a90c229df39badc623b5bbb4e7ac3530e7f5cc5b62b72d375d90b05d75bbc"

  bottle do
    cellar :any_skip_relocation
    sha256 "5855943db8a32bcf8587c456be3c95a1da6b24623a5a12c3a8b0ee2954d71b5f" => :el_capitan
    sha256 "7534443455b082f7019ec9e311128b99442bdcae21cada3f00acd1c8125e2443" => :yosemite
    sha256 "82176a954409a2db7194dbe53f194a5aa1956cb806108608ebd642c730e98a8a" => :mavericks
  end

  depends_on :java => "1.6+"
  depends_on "sbt" => :build

  def install
    ENV["_JAVA_OPTIONS"] = "-Duser.home=#{buildpath}"
    system "sbt", "repl/assembly"
    bin.install "repl/target/scala-2.11/ammonite-repl-0.5.0-2.11.7" => "amm"
  end

  test do
    ENV["_JAVA_OPTIONS"] = "-Duser.home=#{testpath}"
    assert_equal "hello world!", shell_output("#{bin}/amm -c 'print(\"hello world!\")'")
  end
end
