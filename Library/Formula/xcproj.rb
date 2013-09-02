require 'formula'

class Xcproj < Formula
  homepage 'https://github.com/0xced/xcproj'
  url 'https://github.com/0xced/xcproj/archive/0.1.tar.gz'
  sha1 '760bba88a25f9aaae2cda299e628490bfe367ad9'

  head 'https://github.com/0xced/xcproj.git'

  depends_on :macos => :mountain_lion
  depends_on :xcode

  def install
    system 'xcodebuild', "-project", "xcproj.xcodeproj",
                         "-target", "xcproj",
                         "SYMROOT=build",
                         "DSTROOT=#{prefix}",
                         "INSTALL_PATH=/bin",
                         "-verbose",
                         "install"
  end

  def caveats
    <<-EOS.undent
      The xcproj binary is bound to the Xcode version that compiled it. If you delete, move or
      rename the Xcode version that compiled the binary, xcproj will fail with the following error:

          The DevToolsCore framework failed to load: DevToolsCore.framework not found

      In which case you will have to remove and rebuild the installed xcproj version.
    EOS
  end
end
