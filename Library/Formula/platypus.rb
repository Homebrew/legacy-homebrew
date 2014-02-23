require "formula"

class Platypus < Formula
  homepage "http://sveinbjorn.org/platypus"
  url "https://github.com/sveinbjornt/Platypus/raw/4.8/Releases/platypus4.8.src.zip"
  sha1 "39d165b9579600cef637b45c70c82307697bb7be"
  head "https://github.com/sveinbjornt/Platypus", :branch => "master"

  depends_on :xcode

  def install
    cd "Platypus 4.8 Source" do
      if MacOS.version >= :mountain_lion
        # Platypus wants to use a compiler that isn't shipped with recent versions of XCode.
        # See https://github.com/Homebrew/homebrew/pull/22618#issuecomment-24898050
        # and https://github.com/sveinbjornt/Platypus/issues/22

        inreplace "Platypus.xcodeproj/project.pbxproj", "GCC_VERSION", "//GCC_VERSION"
      end
      system "xcodebuild", "SYMROOT=build", "DSTROOT=#{buildpath}",
                           "-project", "Platypus.xcodeproj",
                           "-target", "platypus",
                           "-target", "ScriptExec",
                           "clean", "install"
      man1.install "CommandLineTool/platypus.1"
    end

    bin.install "platypus_clt" => "platypus"
    cd "ScriptExec.app/Contents" do
      (share/"platypus").install "Resources/MainMenu.nib", "MacOS/ScriptExec"
    end
  end

  test do
    system "#{bin}/platypus", "-v"
  end

  def caveats
    <<-EOS.undent
      This formula only installs the command-line Platypus tool, not the GUI.
      If you want the GUI, download the app from the project's Web page directly.
    EOS
  end
end
