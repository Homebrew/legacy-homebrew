require 'formula'

class Appledoc < Formula
  homepage 'http://appledoc.gentlebytes.com/'
  url "https://github.com/tomaz/appledoc/tarball/v2.0.5"
  sha1 'c310584b16812826a1b054d2b96e040c82d709ff'

  head 'https://github.com/tomaz/appledoc.git', :branch => 'master'

  depends_on :xcode # For working xcodebuild.

  def install
    system "xcodebuild", "-project", "appledoc.xcodeproj",
                         "-target", "appledoc",
                         "-configuration", "Release",
                         "install",
                         "SYMROOT=build",
                         "DSTROOT=build",
                         "INSTALL_PATH=/bin"
    bin.install "build/bin/appledoc"
    prefix.install "Templates/"
  end

  def caveats; <<-EOS.undent
    Make the documentation templates available to `appledoc':
      ln -sf "#{prefix}/Templates" "#{ENV['HOME']}/Library/Application Support/appledoc"

    If you have edited the templates yourself, you should check for important changes.

    NOTE someone should patch this tool so this caveat is unecessary.
    EOS
  end

  def test
    system "#{bin}/appledoc", "--version"
  end
end
