require 'formula'

class ClassDump < Formula
  homepage 'http://www.codethecode.com/projects/class-dump/'
  head 'https://github.com/nygard/class-dump.git'
  url 'http://www.codethecode.com/download/class-dump-3.4.tar.bz2'
  sha1 'bc6d9542af201028ae980b9d0497b491ce98227f'

  def install
    if build.head?
      system "xcodebuild", "-configuration", "Release", "SYMROOT=build", "PREFIX=#{prefix}", "ONLY_ACTIVE_ARCH=YES"
      bin.install "build/Release/class-dump"
    else
      bin.install 'class-dump'
    end
  end
end
