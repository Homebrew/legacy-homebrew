require "formula"

class SwitchaudioOsx < Formula
  homepage "https://github.com/FriskyElectrocat/switchaudio-osx/"
  url "https://github.com/FriskyElectrocat/switchaudio-osx/archive/0.0.1-unofficial.tar.gz"
  sha1 "7b0dc8569e81d997dd288b4623a9687feecce139"
  head "https://github.com/FriskyElectrocat/switchaudio-osx.git"

  depends_on :macos => :lion
  depends_on :xcode => :build

  def install
    xcodebuild "-project", "AudioSwitcher.xcodeproj",
               "-target", "SwitchAudioSource",
               "SYMROOT=build",
               "-verbose"
    prefix.install Dir['build/Release/*']
    inner_binary = "#{prefix}/SwitchAudioSource"
    bin.write_exec_script inner_binary
    chmod 0755, bin/'SwitchAudioSource'
  end

  test do
    system "SwitchAudioSource -c"
  end
end
