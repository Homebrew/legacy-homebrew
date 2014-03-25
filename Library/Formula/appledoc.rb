require 'formula'

class Appledoc < Formula
  homepage 'http://appledoc.gentlebytes.com/'
  url "https://github.com/tomaz/appledoc/archive/v2.2-963.tar.gz"
  sha1 '8491dc9ae8fa6bc69da9dcedca601529af3bf4e6'
  version '2.2-963'

  head 'https://github.com/tomaz/appledoc.git', :branch => 'master'

  depends_on :xcode
  depends_on :macos => :lion

  def install
    xcodebuild "-project", "appledoc.xcodeproj",
               "-target", "appledoc",
               "-configuration", "Release",
               "clean", "install",
               "SYMROOT=build",
               "DSTROOT=build",
               "INSTALL_PATH=/bin",
               # 2.2-963 no longer actually uses ObjC GC, but will still
               # try to build with it due to this flag and hence will fail.
               "GCC_ENABLE_OBJC_GC=unsupported",
               "OTHER_CFLAGS='-DCOMPILE_TIME_DEFAULT_TEMPLATE_PATH=@\"#{prefix}/Templates\"'"
    bin.install "build/bin/appledoc"
    prefix.install "Templates/"
  end

  test do
    system "#{bin}/appledoc", "--version"
  end
end
