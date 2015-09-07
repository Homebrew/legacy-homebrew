class GitOctopus < Formula
  desc "Extends git-merge with branch naming patterns"
  homepage "https://github.com/lesfurets/git-octopus"
  url "https://github.com/lesfurets/git-octopus/archive/v1.1.tar.gz"
  sha256 "cc0f64be23a385a18e8cd7e913a54e582f9c8c07460b2c50b0df46b83fc3769d"

  bottle do
    cellar :any
    sha256 "be33fe6c653675fb777b830ba7b5ba5d41986e87bcd2d79d5887240862c287a9" => :yosemite
    sha256 "8fa36a0ea95851074f36b0375f0138293f7c3aa0fc6f819a14987e4c1dc520ee" => :mavericks
    sha256 "7c953c0d60e50045229f63d9efecb9a9b25791f336efde09b91026067102682e" => :mountain_lion
  end

  def install
    system "make", "build"
    bin.install "bin/git-octopus", "bin/git-conflict", "bin/git-apply-conflict-resolution"
    man1.install "doc/git-octopus.1", "doc/git-conflict.1"
  end

  test do
    system "#{bin}/git-octopus"
  end
end
