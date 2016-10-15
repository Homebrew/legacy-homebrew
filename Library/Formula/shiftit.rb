require "formula"

class Shiftit < Formula
  homepage "https://github.com/fikovnik/ShiftIt"
  url "https://github.com/fikovnik/ShiftIt/archive/version-1.5.tar.gz"
  sha1 "4b60d99b73f49af5a2e45156d574f57c74a360b8"
  head "https://github.com/fikovnik/ShiftIt.git", :branch => "develop"

  depends_on :xcode
  depends_on :x11 => :optional if build.stable?

  def install
    args = []
    if build.head?
      args << "-target" << "ShiftIt"
    else
      args << "-target" << "ShiftIt-noX11"
    end

    args << "-project" << "ShiftIt/ShiftIt.xcodeproj"
    args << "-configuration" << "Release"
    args << "-verbose"
    args << "SYMROOT=build"
    args << "DSTROOT=build"
    args << "SDKROOT="
    args << "OTHER_CFLAGS='-DNDEBUG'"
    args << "IBC_PLUGINS=ShortcutRecorder.framework/Versions/A/Resources/ShortcutRecorder.ibplugin"

    xcodebuild *args
    prefix.install "ShiftIt/build/Release/ShiftIt.app"
  end
end
