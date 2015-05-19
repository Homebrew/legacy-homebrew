class RbenvDefaultGems < Formula
  desc "Auto-installs gems for Ruby installs"
  homepage "https://github.com/sstephenson/rbenv-default-gems"
  url "https://github.com/sstephenson/rbenv-default-gems/archive/v1.0.0.tar.gz"
  sha1 "e79c7073909e24e866df49cf9eb3f18aa8872842"

  head "https://github.com/sstephenson/rbenv-default-gems.git"

  depends_on "rbenv"
  depends_on "ruby-build"

  # Upstream patch: https://github.com/sstephenson/rbenv-default-gems/pull/3
  patch do
    url "https://github.com/sstephenson/rbenv-default-gems/commit/ead67889c91c53ad967f85f5a89d986fdb98f6fb.diff"
    sha1 "9d1c5e635752caa7dcee8fb43e2d0e20c1d494ed"
  end

  def install
    prefix.install Dir["*"]
  end

  test do
    assert shell_output("rbenv hooks install").include? "default-gems.bash"
  end
end
