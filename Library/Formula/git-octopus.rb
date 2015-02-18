class GitOctopus < Formula
  homepage "https://github.com/lesfurets/git-octopus"
  url "https://github.com/lesfurets/git-octopus/archive/v1.0.tar.gz"
  def install
    bin.install "bin/git-octopus"
    man1.install "man/man1/git-octopus.1"
  end
  test do
    system "#{bin}/git-octopus"
  end
end
