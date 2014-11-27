require 'formula'

class MPlayerPresented < Requirement
  fatal true
  default_formula 'mplayer'

  satisfy { which('mplayer') || which('mplayer2') }
end

class Mplayershell < Formula
  homepage 'https://github.com/donmelton/MPlayerShell'
  url 'https://github.com/donmelton/MPlayerShell/archive/0.9.3.tar.gz'
  sha1 '22af911cfd379d34756c0a59b07fcdeaad77c493'

  head 'https://github.com/donmelton/MPlayerShell.git'

  bottle do
    cellar :any
    sha1 "fc5c7c41b3537b8fd77b063cb926813e01be21e5" => :mavericks
    sha1 "07d4cdafc128653a5268fa9e699041c5438366a6" => :mountain_lion
    sha1 "d48c7897bbaf5b962fca94b1af24fccd932bd72e" => :lion
  end

  depends_on MPlayerPresented
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
