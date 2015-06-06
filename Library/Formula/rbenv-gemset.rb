class RbenvGemset < Formula
  desc "Adds basic gemset support to rbenv"
  homepage "https://github.com/jf/rbenv-gemset"
  url "https://github.com/jf/rbenv-gemset/archive/v0.5.8.tar.gz"
  sha1 "bd06efff2fcfaeb47bd32dc1658e4aae5d8a0619"

  head "https://github.com/jf/rbenv-gemset.git"

  depends_on "rbenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert shell_output("rbenv hooks exec").include? "gemset.bash"
  end
end
