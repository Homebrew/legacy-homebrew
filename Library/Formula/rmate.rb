class Rmate < Formula
  desc "Edit files from an SSH session in TextMate"
  homepage "https://github.com/textmate/rmate"
  url "https://github.com/textmate/rmate/archive/v1.5.7.tar.gz"
  sha256 "a84105e2c986ef39def5147fa83b8607bab41502177040f4324f5f94946a8e50"
  head "https://github.com/textmate/rmate.git"

  bottle :unneeded

  def install
    bin.install "bin/rmate"
  end

  test do
    system "#{bin}/rmate", "--version"
  end
end
