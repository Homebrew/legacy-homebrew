require 'formula'

class ClassDump < Formula
  homepage 'http://www.codethecode.com/projects/class-dump/'
  url 'https://github.com/nygard/class-dump.git', :tag => '3.4'
  head 'https://github.com/nygard/class-dump.git'

  def install
    system "xcodebuild", "-configuration", "Release", "SYMROOT=build", "PREFIX=#{prefix}", "ONLY_ACTIVE_ARCH=YES"
    bin.install "build/Release/class-dump"
  end
end
