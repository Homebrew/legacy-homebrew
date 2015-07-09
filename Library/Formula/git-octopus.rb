class GitOctopus < Formula
  desc "Extends git-merge with branch naming patterns"
  homepage "https://github.com/lesfurets/git-octopus"
  url "https://github.com/lesfurets/git-octopus/archive/v1.0.tar.gz"
  sha256 "c83ab4aa3d8ec770f4f05619239a7852c871216a108b4e287c13efb10e3db5db"

  head "https://github.com/lesfurets/git-octopus.git"

  bottle do
    cellar :any
    sha256 "be33fe6c653675fb777b830ba7b5ba5d41986e87bcd2d79d5887240862c287a9" => :yosemite
    sha256 "8fa36a0ea95851074f36b0375f0138293f7c3aa0fc6f819a14987e4c1dc520ee" => :mavericks
    sha256 "7c953c0d60e50045229f63d9efecb9a9b25791f336efde09b91026067102682e" => :mountain_lion
  end

  def install
    bin.install "bin/git-octopus"
    man1.install "man/man1/git-octopus.1"
  end

  test do
    system "#{bin}/git-octopus"
  end
end
