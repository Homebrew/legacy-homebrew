class NodenvUpdate < Formula
  desc "Update nodenv plugins not installed with Homebrew"
  homepage "https://github.com/charlesbjohnson/nodenv-update"
  url "https://github.com/charlesbjohnson/nodenv-update/archive/v0.2.0.tar.gz"
  sha256 "25c3297b9cc5428e67519fe70336000396db258046076fa89b6c5aa772964b74"
  head "https://github.com/charlesbjohnson/nodenv-update.git"

  depends_on "nodenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match /^update$/, shell_output("nodenv commands")
  end
end
