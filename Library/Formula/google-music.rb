require "formula"

class GoogleMusic < Formula
  homepage "https://github.com/kbhomes/google-music-mac"
  url "https://github.com/kbhomes/google-music-mac/archive/v1.0.3.tar.gz"
  sha1 "8faa90f9c42951b2a8fcb4af847780750bc3a333"

  depends_on :xcode

  def install
    xcodebuild "-configuration", "Release", "ONLY_ACTIVE_ARCH=YES", "SYMROOT=build"
    bin.install 'build/Release/Google Music.app'
  end

  def caveats; <<-EOS
    Google Music.app was installed in:
    #{prefix}
    To symlink into ~/Applications, you can do:
      brew linkapps
    or
      sudo ln -s #{prefix}/Google Music.app.app /Applications
    EOS
  end
end
