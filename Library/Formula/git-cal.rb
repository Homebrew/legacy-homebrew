require 'formula'

class GitCal < Formula
  homepage 'https://github.com/k4rthik/git-cal'
  url 'https://github.com/k4rthik/git-cal/archive/v0.9.1.tar.gz'
  sha1 '74c70107c9580c0455e01414ccae7333a746bca1'

  def install
    bin.install 'git-cal'
  end

  test do
    # git-cal fails when run outside of a git repo.
    HOMEBREW_REPOSITORY.cd do
      system "#{bin}/git-cal"
    end
  end
end
