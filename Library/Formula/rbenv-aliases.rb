class RbenvAliases < Formula
  desc "Make aliases for Ruby versions"
  homepage "https://github.com/tpope/rbenv-aliases"
  url "https://github.com/tpope/rbenv-aliases/archive/v1.0.1.tar.gz"
  sha256 "f3dca4c584e83f14ba5f624b6e08bd4ac3d4c7ce3874d479e391ae35ac8a3b80"

  head "https://github.com/tpope/rbenv-aliases.git"

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert shell_output("rbenv hooks install").include? "autoalias.bash"
  end
end
