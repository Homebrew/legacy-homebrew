class Unar < Formula
  desc "RAR archive command-line tools"
  homepage "https://unarchiver.c3.cx/commandline"
  url "https://wakaba.c3.cx/releases/TheUnarchiver/unar1.9.1_src.zip"
  sha256 "28045fb688563c002b7c2807e80575d3f9af8eb024739f9ab836f681bb8e822c"
  version "1.9.1"

  head "https://bitbucket.org/WAHa_06x36/theunarchiver", :using => :hg

  depends_on :xcode => :build

  bottle do
    cellar :any
    sha256 "3f0abeedfdc17860ef6f8f8406b34cc6fb2b334e13c3081d00fb7c2ef98f7cc1" => :el_capitan
    sha256 "829f81a91ebb65385bb5b39944f40a8a6a3a900e4717ef00cf608fec2884e3d6" => :yosemite
  end

  def install
    # Files in unar1.9.1_src.zip have "The Unarchiver" path prefix, but HEAD checkout does not.
    # Build on some versions of Xcode will fail if there's whitespace in path, so workaround
    # by moving things out of "The Unarchiver" folder.
    unless build.head?
      mv "./The Unarchiver/Extra", "."
      mv "./The Unarchiver/UniversalDetector", "."
      mv "./The Unarchiver/XADMaster", "."
    end

    # Build XADMaster.framework, unar and lsar
    xcodebuild "-project", "./XADMaster/XADMaster.xcodeproj", "-target", "XADMaster", "SYMROOT=../", "-configuration", "Release"
    xcodebuild "-project", "./XADMaster/XADMaster.xcodeproj", "-target", "unar", "SYMROOT=../", "-configuration", "Release"
    xcodebuild "-project", "./XADMaster/XADMaster.xcodeproj", "-target", "lsar", "SYMROOT=../", "-configuration", "Release"

    bin.install "./Release/unar", "./Release/lsar"

    lib.install "./Release/libXADMaster.a"
    frameworks.install "./Release/XADMaster.framework"
    (include/"libXADMaster").install_symlink Dir["#{frameworks}/XADMaster.framework/Headers/*"]

    cd "./Extra" do
      man1.install "lsar.1", "unar.1"
      bash_completion.install "unar.bash_completion", "lsar.bash_completion"
    end
  end

  test do
    system bin/"unar", "--version"
    system bin/"lsar", "--version"
  end
end
