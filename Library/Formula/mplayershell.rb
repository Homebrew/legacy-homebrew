class MPlayerRequirement < Requirement
  fatal true
  default_formula "mplayer"

  satisfy { which("mplayer") || which("mplayer2") }
end

class Mplayershell < Formula
  desc "Improved visual experience for MPlayer on OS X"
  homepage "https://github.com/donmelton/MPlayerShell"
  url "https://github.com/donmelton/MPlayerShell/archive/0.9.3.tar.gz"
  sha256 "a1751207de9d79d7f6caa563a3ccbf9ea9b3c15a42478ff24f5d1e9ff7d7226a"

  head "https://github.com/donmelton/MPlayerShell.git"

  bottle do
    cellar :any
    sha256 "1637360e180d7b48367cb7c4f01d03856b9d13247000e4cc33f0af5f6ed92101" => :yosemite
    sha256 "a95437813704c56c3e52bd1b17974bec24c209e26df8e9dfe07af45d51ecaf49" => :mavericks
    sha256 "0553f3ff5cae0a8938c3dc09e6448621029b52bbbc6c17d53225c1f3e7881ae4" => :mountain_lion
  end

  depends_on MPlayerRequirement
  depends_on :macos => :lion
  depends_on :xcode => :build

  def install
    xcodebuild "-project",
               "MPlayerShell.xcodeproj",
               "-target", "mps",
               "-configuration", "Release",
               "clean", "build",
               "SYMROOT=build",
               "DSTROOT=build"
    bin.install "build/Release/mps"
    man1.install "Source/mps.1"
  end

  test do
    system "#{bin}/mps"
  end
end
