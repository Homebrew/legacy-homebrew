require 'formula'

class Appledoc < Formula
  homepage 'http://appledoc.gentlebytes.com/'
  url "https://github.com/tomaz/appledoc/archive/v2.2.tar.gz"
  sha1 '4ad475ee6bdc2e34d6053c4e384aad1781349f5e'

  head 'https://github.com/tomaz/appledoc.git', :branch => 'master'

  depends_on :xcode
  depends_on :macos => :lion

  def install
    system "xcodebuild", "-project", "appledoc.xcodeproj",
                         "-target", "appledoc",
                         "-configuration", "Release",
                         "clean", "install",
                         "SYMROOT=build",
                         "DSTROOT=build",
                         "INSTALL_PATH=/bin",
                         "OTHER_CFLAGS='-DCOMPILE_TIME_DEFAULT_TEMPLATE_PATH=@\"#{prefix}/Templates\"'"
    bin.install "build/bin/appledoc"
    prefix.install "Templates/"
  end

  def test
    system "#{bin}/appledoc", "--version"
  end
end
