require 'formula'

class Appledoc < Formula
  homepage 'http://appledoc.gentlebytes.com/'
  url "https://github.com/tomaz/appledoc/archive/v2.2-963.tar.gz"
  sha1 '8491dc9ae8fa6bc69da9dcedca601529af3bf4e6'
  version '2.2-963'

  head 'https://github.com/tomaz/appledoc.git', :branch => 'master'

  depends_on :xcode
  depends_on :macos => :lion

  # Actually works with pre-503 clang, but we don't have a way to
  # express this yet.
  # clang 5.1 (build 503) removed support for Objective C GC, and
  # there is no stable version of Appledoc with support for ARC yet.
  # It's actually possible to build with GC disabled, but not advisable.
  # See: https://github.com/tomaz/appledoc/issues/439
  fails_with :clang

  def install
    xcodebuild "-project", "appledoc.xcodeproj",
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

  test do
    system "#{bin}/appledoc", "--version"
  end
end
