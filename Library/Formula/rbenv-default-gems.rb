class RbenvDefaultGems < Formula
  desc "Auto-installs gems for Ruby installs"
  homepage "https://github.com/sstephenson/rbenv-default-gems"
  url "https://github.com/sstephenson/rbenv-default-gems/archive/v1.0.0.tar.gz"
  sha256 "8271d58168ab10f0ace285dc4c394e2de8f2d1ccc24032e6ed5924f38dc24822"

  head "https://github.com/sstephenson/rbenv-default-gems.git"

  depends_on "rbenv"
  depends_on "ruby-build"

  # Upstream patch: https://github.com/sstephenson/rbenv-default-gems/pull/3
  patch do
    url "https://github.com/sstephenson/rbenv-default-gems/commit/ead67889c91c53ad967f85f5a89d986fdb98f6fb.diff"
    sha256 "14cab3c3a0baa8b138bdb4d898f6a1cf3b42c70927cd2e8139005e401a17d807"
  end

  def install
    prefix.install Dir["*"]
  end

  test do
    assert shell_output("rbenv hooks install").include? "default-gems.bash"
  end
end
