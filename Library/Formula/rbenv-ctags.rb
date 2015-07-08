class RbenvCtags < Formula
  desc "Automatically generate ctags for rbenv Ruby stdlibs"
  homepage "https://github.com/tpope/rbenv-ctags"
  url "https://github.com/tpope/rbenv-ctags/archive/v1.0.1.tar.gz"
  sha1 "551ce03a0f6709dd2209c2bd319344f521769420"

  head "https://github.com/tpope/rbenv-ctags.git"

  depends_on "rbenv"
  depends_on "ctags"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert shell_output("rbenv hooks install").include? "ctags.bash"
  end
end
