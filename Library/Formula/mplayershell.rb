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
    sha1 "5b280e20e9f690914906c41da02671b6c4667657" => :yosemite
    sha1 "e12cbcf444c89071bdc4a0d8cea731d222444817" => :mavericks
    sha1 "4993ca2b08d334843db0c31a35003424a4342a66" => :mountain_lion
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
