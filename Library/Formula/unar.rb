class Unar < Formula
  desc "RAR archive command-line tools"
  homepage "http://unarchiver.c3.cx/commandline"
  url "http://unarchiver.c3.cx/downloads/unar1.9.1_src.zip"
  sha256 "28045fb688563c002b7c2807e80575d3f9af8eb024739f9ab836f681bb8e822c"
  version "1.9.1"

  head "https://bitbucket.org/WAHa_06x36/theunarchiver", :using => :hg

  depends_on :xcode => :build

  bottle do
    cellar :any
    revision 2
    sha256 "3b6c6c9b3daad466a48d2212990303afee2e7b4d7104bea8300d67bd9a1b801d" => :el_capitan
    sha1 "cb7c91f0aab580a0d4edb2db4934b7879cb468e3" => :mavericks
    sha1 "35f2b3655adfed8daed2eee14f757c0ada553c00" => :mountain_lion
    sha1 "a6254624528195ab69b6adf3b649571814b4d638" => :lion
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
