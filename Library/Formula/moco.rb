require "formula"

class Moco < Formula
  homepage "https://github.com/dreamhead/moco"
  url "http://central.maven.org/maven2/com/github/dreamhead/moco-runner/0.9.2/moco-runner-0.9.2-standalone.jar"
  sha1 "a21445d7b275c48874ed7756477ade74de299e17"

  def install
    libexec.install "moco-runner-0.9.2-standalone.jar"
    bin.write_jar_script libexec/"moco-runner-0.9.2-standalone.jar", "moco"
  end
end
