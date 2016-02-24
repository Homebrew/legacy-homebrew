class Fasd < Formula
  desc "CLI tool for quick access to files and directories"
  homepage "https://github.com/clvv/fasd"
  url "https://github.com/clvv/fasd/archive/1.0.1.tar.gz"
  sha256 "88efdfbbed8df408699a14fa6c567450bf86480f5ff3dde42d0b3e1dee731f65"

  bottle :unneeded

  def install
    bin.install "fasd"
    man1.install "fasd.1"
  end

  test do
    system "#{bin}/fasd", "--init", "auto"
  end
end
