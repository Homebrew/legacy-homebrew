class ClassDump < Formula
  desc "Utility for examining the Objective-C segment of Mach-O files"
  homepage "http://stevenygard.com/projects/class-dump/"
  head "https://github.com/nygard/class-dump.git"
  url "https://github.com/nygard/class-dump/archive/3.5.tar.gz"
  sha256 "94f5286c657dca02dbed4514b2dbd791b42ecef5122e3945a855caf8d1f65e64"

  bottle do
    cellar :any
    sha1 "f87501bf78ff05444c12347d874a81d9b87445dc" => :mavericks
  end

  depends_on :macos => :mavericks
  depends_on :xcode => :build

  def install
    xcodebuild "-configuration", "Release", "SYMROOT=build", "PREFIX=#{prefix}", "ONLY_ACTIVE_ARCH=YES"
    bin.install "build/Release/class-dump"
  end
end
