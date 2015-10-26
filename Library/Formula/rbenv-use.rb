class RbenvUse < Formula
  desc "Switch between rubies without reference to patch levels"
  homepage "https://github.com/rkh/rbenv-use"
  url "https://github.com/rkh/rbenv-use/archive/v1.0.0.tar.gz"
  sha256 "f831dc9b8a43e30499e62928d13f5d354bf4c505b3f6b7fc1a1a9956ed9e538c"

  bottle :unneeded

  depends_on "rbenv"
  depends_on "rbenv-whatis"

  def install
    prefix.install Dir["*"]
  end

  test do
    shell_output("eval \"$(rbenv init -)\" && rbenv use system")
  end
end
