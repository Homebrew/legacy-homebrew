class RbenvAliases < Formula
  desc "Make aliases for Ruby versions"
  homepage "https://github.com/tpope/rbenv-aliases"
  url "https://github.com/tpope/rbenv-aliases/archive/v1.0.1.tar.gz"
  sha1 "7fcfe5ea3011c5f9e00ad41d85bebc2d19869b61"

  head "https://github.com/tpope/rbenv-aliases.git"

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert shell_output("rbenv hooks install").include? "autoalias.bash"
  end
end
