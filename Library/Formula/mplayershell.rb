require 'formula'
require 'macos'

class LionOrHigher < Requirement
  fatal true

  satisfy { MacOS.version >= :lion }

  def message
    "MPlayerShell requires OS X 10.7 (Lion) or newer"
  end
end

class MplayerPresented < Requirement
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
  url 'https://github.com/donmelton/MPlayerShell/archive/0.9.0.tar.gz'
  sha1 '0ed15622abd020b1924aaead7f3e373f36c98a47'

  head 'https://github.com/donmelton/MPlayerShell.git'

  depends_on MplayerPresented
  depends_on LionOrHigher
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
