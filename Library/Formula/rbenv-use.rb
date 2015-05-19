class RbenvUse < Formula
  desc "Switch between rubies without reference to patch levels"
  homepage "https://github.com/rkh/rbenv-use"
  url "https://github.com/rkh/rbenv-use/archive/v1.0.0.tar.gz"
  sha1 "39beb889704bc51213665fd994417ab0668c5f83"

  depends_on "rbenv"
  depends_on "rbenv-whatis"

  def install
    prefix.install Dir["*"]
  end

  test do
    shell_output("eval \"$(rbenv init -)\" && rbenv use system")
  end
end
