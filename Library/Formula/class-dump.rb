require 'formula'

class ClassDump < Formula
  homepage 'http://stevenygard.com/projects/class-dump/'
  head 'https://github.com/nygard/class-dump.git'
  url 'https://github.com/nygard/class-dump/archive/3.5.tar.gz'
  sha1 'c343bec63878161b02c956f49c9c1c8d989b4b5a'

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
