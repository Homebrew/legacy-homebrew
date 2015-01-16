require "formula"

class Bfg < Formula
  homepage "https://rtyley.github.io/bfg-repo-cleaner/"
  url "https://repo1.maven.org/maven2/com/madgag/bfg/1.11.10/bfg-1.11.10.jar"
  sha1 "c514a5649e9440e4b174ccc46faf8c38c6fb824f"

  bottle do
    cellar :any
    sha1 "aa138b3e29c4e1e091a34d454318a272ba7a07ef" => :yosemite
    sha1 "b804d878d845fce21a33ae553a3e78cd7246bb70" => :mavericks
    sha1 "b98e1cfe586b09b8d2f57cc590966cc677ffa595" => :mountain_lion
  end

  def install
    libexec.install "bfg-1.11.10.jar"
    bin.write_jar_script libexec/"bfg-1.11.10.jar", "bfg"
  end

  test do
    system "#{bin}/bfg"
  end
end
