require "formula"

class Launch4j < Formula
  homepage "http://launch4j.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/launch4j/launch4j-3/3.5/launch4j-3.5-macosx-x86-10.8.tgz"
  sha1 "1c93d390c68894a1a82ef936ea5320f0f5035afe"
  version "3.5"

  def install
    libexec.install Dir["*"] - ["src", "web"]
    bin.write_jar_script libexec/"launch4j.jar", "launch4j"
  end
end
