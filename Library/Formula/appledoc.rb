require 'formula'

class Appledoc < Formula
  homepage 'http://appledoc.gentlebytes.com/'
  url "https://github.com/tomaz/appledoc/tarball/v2.1"
  sha1 'd3bd05ce3f7b755cd0dfcb15316bc9f667c1ff2f'

  head 'https://github.com/tomaz/appledoc.git', :branch => 'master'

  depends_on :xcode # For working xcodebuild.

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
