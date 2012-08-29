require 'formula'

class Appledoc < Formula
  url "https://github.com/tomaz/appledoc/tarball/v2.0.5"
  head 'https://github.com/tomaz/appledoc.git', :branch => 'master'
  homepage 'http://appledoc.gentlebytes.com/'
  md5 '142cf80513ca8eda2aba631483b2e4e6'

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

  def caveats; <<-EOS
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
