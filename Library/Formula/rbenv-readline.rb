class RbenvReadline < Formula
  desc "Automatically link Ruby installs to readline"
  homepage "https://github.com/tpope/rbenv-readline"
  url "https://github.com/tpope/rbenv-readline/archive/v1.0.0.tar.gz"
  sha1 "2b9484548bb9ea6a72757a0ff750e48b74b9e1f7"

  head "https://github.com/tpope/rbenv-readline.git"

  depends_on "rbenv"
  depends_on "ruby-build"
  depends_on "readline"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert shell_output("rbenv hooks install").include? "readline-brew.bash"
  end
end
