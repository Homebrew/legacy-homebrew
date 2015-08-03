class Launch4j < Formula
  desc "Cross-platform Java executable wrapper"
  homepage "http://launch4j.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/launch4j/launch4j-3/3.5/launch4j-3.5-macosx-x86-10.8.tgz"
  sha256 "d994287342c0bbeaf3b967ccbf9bfb18d1a5b7123bca529c79760e67d6fd1e5f"
  version "3.5"

  def install
    libexec.install Dir["*"] - ["src", "web"]
    bin.write_jar_script libexec/"launch4j.jar", "launch4j"
  end
end
