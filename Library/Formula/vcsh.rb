class Vcsh < Formula
  desc "Config manager based on git"
  homepage "https://github.com/RichiH/vcsh"
  url "https://github.com/RichiH/vcsh/archive/v1.20151229-1.tar.gz"
  version "1.20151229-1"
  sha256 "7682a517eaf88a86ea5e38ad81707800e965375eaff8b5cfd882e210fe2fef71"

  bottle :unneeded

  def install
    bin.install "vcsh"
    man1.install "vcsh.1"
    zsh_completion.install "_vcsh"
  end

  test do
    assert_match /Initialized empty/, shell_output("#{bin}/vcsh init test").strip
  end
end
