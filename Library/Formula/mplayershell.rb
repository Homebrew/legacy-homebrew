require 'formula'

class MPlayerPresented < Requirement
  fatal true
  default_formula 'mplayer'

  satisfy { which('mplayer') || which('mplayer2') }

  def message; <<-EOS.undent
    MPlayerShell requires mplayer or mplayer2 to be installed.

    You can use either
      brew install mplayer
    or
      brew tap pigoz/mplayer2
      brew install mplayer2
    EOS
  end
end

class Mplayershell < Formula
  homepage 'https://github.com/donmelton/MPlayerShell'
  url 'https://github.com/donmelton/MPlayerShell/archive/0.9.1.tar.gz'
  sha1 'fe009b774eca8e8a8e3030a49cdd463f5b368b27'

  head 'https://github.com/donmelton/MPlayerShell.git'

  depends_on MPlayerPresented
  depends_on :macos => :lion
  depends_on :xcode

  def install
    system "xcodebuild", "-project", "MPlayerShell.xcodeproj",
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
