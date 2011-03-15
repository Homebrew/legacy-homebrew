require 'formula'

class Sleepnow < Formula
  url 'http://www.snoize.com/SleepNow/SleepNow.tar.gz'
  version '20070603' # Jun  3  2007 source
  homepage 'http://www.snoize.com/SleepNow/'
  md5 'a9555e48d9719868dd9ec7ce1423861b'

  def install
    Dir.chdir('Source') do
      # Remove unneeded SDK reference
      inreplace "SleepNow.xcodeproj/project.pbxproj", /SDKROOT.*$/, ''

      # Build binary
      system "xcodebuild", "-target", "SleepNow", "-configuration", "Release", "ONLY_ACTIVE_ARCH=YES", "SYMROOT=build"

      # Install binary and rename to lowercase
      bin.install 'build/Release/SleepNow' => 'sleepnow'
    end
  end
end
