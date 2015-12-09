class RbenvCtags < Formula
  desc "Automatically generate ctags for rbenv Ruby stdlibs"
  homepage "https://github.com/tpope/rbenv-ctags"
  url "https://github.com/tpope/rbenv-ctags/archive/v1.0.1.tar.gz"
  sha256 "d3bf7168da9472e361512f72add7962af0f89b9c264721d0ac0597ab5b1b98af"
  head "https://github.com/tpope/rbenv-ctags.git"

  bottle :unneeded

  depends_on "rbenv"
  depends_on "ctags"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "ctags.bash", shell_output("rbenv hooks install")
  end
end
