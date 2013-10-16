require 'formula'

class GitCal < Formula
  homepage 'https://github.com/k4rthik/git-cal'
  url 'https://github.com/k4rthik/git-cal/archive/v0.9.tar.gz'
  sha1 'dd4027e367382a8593cab4212d2c7882a7b37680'

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
