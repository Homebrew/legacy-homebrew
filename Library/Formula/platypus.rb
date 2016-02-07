class Platypus < Formula
  desc "Create OS X applications from {Perl,Ruby,sh,Python} scripts"
  homepage "http://sveinbjorn.org/platypus"
  url "http://sveinbjorn.org/files/software/platypus/platypus5.1.src.zip"
  version "5.1"
  sha256 "7ff3a5e7c5a01603855e3294763d5603b90f8cfa100670771abc1097fd85fc7a"
  head "https://github.com/sveinbjornt/Platypus.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c48c2b021df9de8b3e14e6b662eda5e1d8952820a50e05297e4cc51998b15980" => :el_capitan
    sha256 "bee357b4dfb3ae25bb2ae31ffe61e5fd0d29076426f587f45096480c998500e6" => :yosemite
  end

  depends_on :xcode => ["7.0", :build]

  def install
    xcodebuild "SYMROOT=build", "DSTROOT=#{buildpath}",
               "-project", "Platypus.xcodeproj",
               "-target", "platypus",
               "-target", "ScriptExec",
               "clean",
               "install"

    man1.install "CommandLineTool/man/platypus.1"

    cd buildpath

    bin.install "platypus_clt" => "platypus"

    cd "build/UninstalledProducts/macosx/ScriptExec.app/Contents" do
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
