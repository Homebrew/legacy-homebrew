class Appledoc < Formula
  desc "Objective-C API documentation generator"
  homepage "http://appledoc.gentlebytes.com/"
  url "https://github.com/tomaz/appledoc/archive/2.2.1.tar.gz"
  sha256 "0ec881f667dfe70d565b7f1328e9ad4eebc8699ee6dcd381f3bd0ccbf35c0337"

  head "https://github.com/tomaz/appledoc.git"

  depends_on :xcode => :build
  depends_on :macos => :lion

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
