class RbenvAliases < Formula
  desc "Make aliases for Ruby versions"
  homepage "https://github.com/tpope/rbenv-aliases"
  url "https://github.com/tpope/rbenv-aliases/archive/v1.1.0.tar.gz"
  sha256 "12e89bc4499e85d8babac2b02bc8b66ceb0aa3f8047b26728a3eca8a6030273d"
  head "https://github.com/tpope/rbenv-aliases.git"

  bottle :unneeded

  depends_on :rbenv

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "autoalias.bash", shell_output("rbenv hooks install")
  end
end
