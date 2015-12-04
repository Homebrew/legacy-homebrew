class SwitchaudioOsx < Formula
  desc "Change OS X audio source from the command-line"
  homepage "https://github.com/deweller/switchaudio-osx/"
  url "https://github.com/deweller/switchaudio-osx/archive/1.0.0.tar.gz"
  sha256 "c00389837ffd02b1bb672624fec7b75434e2d72d55574afd7183758b419ed6a3"
  head "https://github.com/deweller/switchaudio-osx.git"

  bottle do
    cellar :any
    sha256 "1fe317d92bd690f9f9b9b4ab3d6b856b02a1213ab1df49d847d53cccf199a8b6" => :mavericks
    sha256 "80dbff685611e2129746f99e535ad8cc6e030606652686594ad8c81b308c5c16" => :mountain_lion
    sha256 "974919281dd0263b866e737bb23e998a2e116f1116a65f20b35fd34be6cd39d1" => :lion
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
