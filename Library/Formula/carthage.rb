require "formula"

class Xcode6_1_1 < Requirement
  fatal true
  satisfy { MacOS::Xcode.version >= "6.1.1" }
end

class Carthage < Formula
  homepage "https://github.com/Carthage/Carthage"
  head "https://github.com/Carthage/Carthage.git", :branch => "homebrewable"
  url "https://github.com/Carthage/Carthage/archive/0.3.tar.gz"
  sha1 "8590ca1c72855b0795c1a9ef558e6002ce1464ed"

  depends_on Xcode6_1_1

  def install
    system %Q{make package XCODEFLAGS="LD_RUNPATH_SEARCH_PATHS='"#{frameworks}" "#{frameworks}/CarthageKit.framework/Versions/Current/Frameworks/" $(inherited)' -workspace Carthage.xcworkspace -scheme carthage"}
    system "make clean"

    bin.install "/tmp/Carthage.dst/usr/local/bin/carthage"
    frameworks.install "/tmp/Carthage.dst/Library/Frameworks/CarthageKit.framework"
  end

  test do
    system bin/"carthage", "version"
  end
end
