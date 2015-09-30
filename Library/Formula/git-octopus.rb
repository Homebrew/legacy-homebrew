class GitOctopus < Formula
  desc "Extends git-merge with branch naming patterns"
  homepage "https://github.com/lesfurets/git-octopus"
  url "https://github.com/lesfurets/git-octopus/archive/v1.1.tar.gz"
  sha256 "cc0f64be23a385a18e8cd7e913a54e582f9c8c07460b2c50b0df46b83fc3769d"

  bottle do
    cellar :any
    sha256 "4979b6cf8a420382ea66d5afa883bdb28f76405c70f56f89a063123d9c6cafdf" => :yosemite
    sha256 "8112153bc59267178cfc95fc1b30adbea362c3cd62bd39947de6b41aedcf0a1d" => :mavericks
    sha256 "08dd8fe44df56b08d525310db0142bb77494ae614ab85ed08ee5fbf263a393d5" => :mountain_lion
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
