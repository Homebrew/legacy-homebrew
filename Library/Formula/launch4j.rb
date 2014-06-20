require "formula"

class Launch4j < Formula
  homepage "http://launch4j.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/launch4j/launch4j-3/3.4/launch4j-3.4-macosx-x86-10.8.tgz"
  sha1 "e3483f4fc835d048ed7352961c3d39e80dbacb87"
  version "3.4"

  def install
    libexec.install Dir["*"] - ["src", "web"]
    bin.write_jar_script libexec/"launch4j.jar", "launch4j"
  end
end
