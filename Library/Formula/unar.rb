class Unar < Formula
  desc "RAR archive command-line tools"
  homepage "http://unarchiver.c3.cx/commandline"
  url "https://theunarchiver.googlecode.com/files/unar1.8.1_src.zip"
  version "1.8.1"
  sha256 "67ccb1c780150840f38de63b8e7047717ef4c71b7574d9ef57bd9d9c93255709"

  head "https://code.google.com/p/theunarchiver/", :using => :hg

  depends_on :xcode => :build

  bottle do
    cellar :any
    revision 2
    sha256 "3b6c6c9b3daad466a48d2212990303afee2e7b4d7104bea8300d67bd9a1b801d" => :el_capitan
    sha256 "b1133a9d6ad0ef36471eba78243ea22e1818525ccc0dd619fecd3189861eae63" => :mavericks
    sha256 "fed764cd8287e0978e1c97b68f39505d5f31a8fa3b896579039b5b5d64eadc9c" => :mountain_lion
    sha256 "cfcbb24f0952548666d5da7aca059c56b4b132c4beb692d1af8bc6c8ce2929f5" => :lion
  end

  def install
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
