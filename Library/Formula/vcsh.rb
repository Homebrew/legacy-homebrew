class Vcsh < Formula
  desc "Config manager based on git"
  homepage "https://github.com/RichiH/vcsh"
  url "https://github.com/RichiH/vcsh/archive/v1.20150502-1.tar.gz"
  version "1.20150502-1"
  sha256 "ffb2f619926eee942da5687262e63f0816b10abdfd7f10bf5f44d50739d5f4d1"

  bottle :unneeded

  def install
    bin.install "vcsh"
    man1.install "vcsh.1"
    zsh_completion.install "_vcsh"
  end

  test do
    system "#{bin}/vcsh"
  end
end
