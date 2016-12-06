class NodenvVars < Formula
  desc "Safely sets global and per-project environment variables"
  homepage "https://github.com/OiNutter/nodenv-vars"
  url "https://github.com/OiNutter/nodenv-vars/archive/v1.2.0.tar.gz"
  sha256 "80b0f2b942067f18d9c725ecad3c192a8ecbf0bb9ad00b9c797d994546bc9ff5"
  head "https://github.com/OiNutter/nodenv-vars.git"

  bottle :unneeded

  depends_on "nodenv"

  def install
    prefix.install Dir["*"]
  end

  test do
    assert_match "nodenv-vars.bash", shell_output("nodenv hooks exec")
  end
end
