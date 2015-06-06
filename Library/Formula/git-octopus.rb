class GitOctopus < Formula
  desc "Extends git-merge with branch naming patterns"
  homepage "https://github.com/lesfurets/git-octopus"
  url "https://github.com/lesfurets/git-octopus/archive/v1.0.tar.gz"
  sha256 "c83ab4aa3d8ec770f4f05619239a7852c871216a108b4e287c13efb10e3db5db"

  def install
    bin.install "bin/git-octopus"
    man1.install "man/man1/git-octopus.1"
  end

  test do
    system "#{bin}/git-octopus"
  end
end
