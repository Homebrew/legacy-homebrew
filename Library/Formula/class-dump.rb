require 'formula'

class ClassDump < Formula
  homepage 'http://stevenygard.com/projects/class-dump/'
  head 'https://github.com/nygard/class-dump.git'
  url 'https://github.com/nygard/class-dump/archive/3.5.tar.gz'
  sha1 'c343bec63878161b02c956f49c9c1c8d989b4b5a'

  depends_on :macos => :mavericks

  def install
    xcodebuild "-configuration", "Release", "SYMROOT=build", "PREFIX=#{prefix}", "ONLY_ACTIVE_ARCH=YES"
    bin.install "build/Release/class-dump"
  end
end
