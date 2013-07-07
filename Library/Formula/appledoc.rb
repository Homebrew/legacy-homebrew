require 'formula'

class Appledoc < Formula
  homepage 'http://appledoc.gentlebytes.com/'
  url "https://github.com/tomaz/appledoc/archive/v2.1.tar.gz"
  sha1 'c30675e340d2ae1334e3d9254701de6f40d6658c'

  head 'https://github.com/tomaz/appledoc.git', :branch => 'master'

  depends_on :xcode # For working xcodebuild.
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
