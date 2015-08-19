class SwitchaudioOsx < Formula
  desc "Change OS X audio source from the command-line"
  homepage "https://github.com/deweller/switchaudio-osx/"
  url "https://github.com/deweller/switchaudio-osx/archive/1.0.0.tar.gz"
  sha256 "c00389837ffd02b1bb672624fec7b75434e2d72d55574afd7183758b419ed6a3"
  head "https://github.com/deweller/switchaudio-osx.git"

  bottle do
    cellar :any
    sha1 "5e5809f498765a2402a3082d3f643f7772f7851f" => :mavericks
    sha1 "419a9487393be1d4b08fae2fc7aa6ab097b7cd75" => :mountain_lion
    sha1 "94e17d2daaefe1118ce7915d26b4cbd0219b07c8" => :lion
  end

  depends_on :macos => :lion
  depends_on :xcode => :build

  def install
    xcodebuild "-project", "AudioSwitcher.xcodeproj",
               "-target", "SwitchAudioSource",
               "SYMROOT=build",
               "-verbose"
    prefix.install Dir["build/Release/*"]
    bin.write_exec_script "#{prefix}/SwitchAudioSource"
    chmod 0755, "#{bin}/SwitchAudioSource"
  end

  test do
    system "#{bin}/SwitchAudioSource", "-c"
  end
end
