class GitHooks < Formula
  desc "Manage project, user, and global Git hooks"
  homepage "https://github.com/icefox/git-hooks"
  url "https://github.com/icefox/git-hooks/archive/1.00.0.tar.gz"
  sha256 "8197ca1de975ff1f795a2b9cfcac1a6f7ee24276750c757eecf3bcb49b74808e"

  def install
    bin.install "git-hooks"
    (etc/"git-hooks").install "contrib"
  end

  test do
    output = `cd $(brew --repository); git hooks`.strip
    assert_match /Listing User, Project, and Global hooks/, output
  end
end
