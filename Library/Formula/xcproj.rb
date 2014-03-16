require 'formula'

class Xcproj < Formula
  homepage 'https://github.com/0xced/xcproj'
  url 'https://github.com/0xced/xcproj/archive/0.1.2.tar.gz'
  sha1 '624ae9349b6c4eaa66d1b57bdd4038548c83c30c'

  head 'https://github.com/0xced/xcproj.git'

  depends_on :macos => :mountain_lion
  depends_on :xcode

  def install
    xcodebuild "-project", "xcproj.xcodeproj",
               "-scheme", "xcproj",
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

          DVTFoundation.framework not found. It probably means that you have deleted, moved or
          renamed the Xcode copy that compiled `xcproj`.
          Simply recompiling `xcproj` should fix this problem.

      In which case you will have to remove and rebuild the installed xcproj version.
    EOS
  end
end
