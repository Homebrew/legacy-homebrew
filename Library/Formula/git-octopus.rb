class GitOctopus < Formula
  desc "Extends git-merge with branch naming patterns"
  homepage "https://github.com/lesfurets/git-octopus"
  url "https://github.com/lesfurets/git-octopus/archive/v1.1.tar.gz"
  sha256 "cc0f64be23a385a18e8cd7e913a54e582f9c8c07460b2c50b0df46b83fc3769d"

  def install
    system "make", "build"
    bin.install "bin/git-octopus"
    bin.install "bin/git-conflict"
    bin.install "bin/git-apply-conflict-resolution"
    man1.install "doc/git-octopus.1"
    man1.install "doc/git-conflict.1"
  end

  test do
    system "#{bin}/git-octopus"
  end
end
