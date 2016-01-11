class Mussh < Formula
  desc "Multi-host SSH wrapper"
  homepage "http://mussh.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/mussh/mussh/1.0/mussh-1.0.tgz"
  sha256 "6ba883cfaacc3f54c2643e8790556ff7b17da73c9e0d4e18346a51791fedd267"

  bottle :unneeded

  def install
    bin.install "mussh"
    man1.install "mussh.1"
  end
end
