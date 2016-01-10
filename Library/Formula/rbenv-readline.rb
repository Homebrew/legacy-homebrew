class RbenvReadline < Formula
  desc "Automatically link Ruby installs to readline"
  homepage "https://github.com/tpope/rbenv-readline"
  url "https://github.com/tpope/rbenv-readline/archive/v1.0.0.tar.gz"
  sha256 "8ce024f47ebcdf7a657412a69f1bc4355769ef1bdede96d88785c5bb69483b77"
  head "https://github.com/tpope/rbenv-readline.git"

  bottle :unneeded

  depends_on :rbenv
  depends_on "readline"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "readline-brew.bash", shell_output("rbenv hooks install")
  end
end
