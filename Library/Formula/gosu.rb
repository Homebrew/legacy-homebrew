class Gosu < Formula
  desc "Pragmatic language for the JVM"
  homepage "http://gosu-lang.org/"
  url "http://gosu-lang.org/nexus/content/repositories/gosu/org/gosu-lang/gosu/gosu/0.10.3/gosu-0.10.3-full.tar.gz"
  sha256 "81ee61e8ca342040f428a5993710db35dd07596a6c5e71953299a9843f74146b"

  bottle :unneeded

  def install
    rm "bin/gosu.cmd"
    touch "ext/.anchor"
    libexec.install Dir["*"]
    bin.install_symlink libexec/"bin/gosu"
  end
end
