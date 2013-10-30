require 'formula'

class ClassDump < Formula
  homepage 'http://www.codethecode.com/projects/class-dump/'
  head 'https://github.com/nygard/class-dump.git'
  url 'https://github.com/nygard/class-dump/archive/3.4.tar.gz'
  sha1 'd8c16e94ec82979fb0e68503a217bd0c2cd5008f'

  depends_on :macos => :lion

  def install
    system "xcodebuild", "-configuration", "Release", "SYMROOT=build", "PREFIX=#{prefix}", "ONLY_ACTIVE_ARCH=YES"
    bin.install "build/Release/class-dump"
  end
end
