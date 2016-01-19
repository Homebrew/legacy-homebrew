class RbenvGemset < Formula
  desc "Adds basic gemset support to rbenv"
  homepage "https://github.com/jf/rbenv-gemset"
  url "https://github.com/jf/rbenv-gemset/archive/v0.5.8.tar.gz"
  sha256 "9ff2d048c9f1c5dd545f5860b33b480a019b970cdc97b2491e15c38b2eb2ce22"
  head "https://github.com/jf/rbenv-gemset.git"

  bottle :unneeded

  depends_on :rbenv

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "gemset.bash", shell_output("rbenv hooks exec")
  end
end
