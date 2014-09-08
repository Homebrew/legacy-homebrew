require "formula"

class Platypus < Formula
  homepage "http://sveinbjorn.org/platypus"
  url "https://raw.githubusercontent.com/sveinbjornt/Platypus/4.8/Releases/platypus4.8.src.zip"
  sha1 "39d165b9579600cef637b45c70c82307697bb7be"
  head "https://github.com/sveinbjornt/Platypus.git", :branch => "master"

  bottle do
    cellar :any
    sha1 "098a47d22181f648bcbe3fa8ca16b1496231d548" => :mavericks
    sha1 "b170417ede5809c752c673e91d3c108ab2124bf5" => :mountain_lion
    sha1 "ec050d53583c57b7ad6d92c2fe3d44d8705824be" => :lion
  end

  depends_on :xcode => :build

  def install
    # 4.8 tarball has extra __MACOSX folder, so go to the right one
    # The head tarball only has a single folder in it
    cd "Platypus 4.8 Source" if build.stable?

    if build.stable? and MacOS.version >= :mountain_lion
      # Platypus wants to use a compiler that isn't shipped with recent versions of XCode.
      # See https://github.com/Homebrew/homebrew/pull/22618#issuecomment-24898050
      # and https://github.com/sveinbjornt/Platypus/issues/22

      inreplace "Platypus.xcodeproj/project.pbxproj", "GCC_VERSION", "//GCC_VERSION"
    end

    xcodebuild "SYMROOT=build", "DSTROOT=#{buildpath}",
               "-project", "Platypus.xcodeproj",
               "-target", "platypus",
               "-target", "ScriptExec",
               "clean",
               "install"

    man1.install "CommandLineTool/platypus.1"

    cd buildpath

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
