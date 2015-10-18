class Platypus < Formula
  desc "Create OS X applications from {Perl,Ruby,sh,Python} scripts"
  homepage "http://sveinbjorn.org/platypus"
  url "https://github.com/sveinbjornt/Platypus/raw/master/Releases/platypus4.9.src.zip"
  version "4.9"
  sha256 "11b32fc5c68b4e73abeeabd22e1547c2c9b53bafe86cf04474c1f78863d2c1ae"
  head "https://github.com/sveinbjornt/Platypus.git"

  bottle do
    cellar :any
    sha256 "398efe2d6afe358e13dc881be58ae8e27c73bd1538ca954e7067c055d25adf75" => :yosemite
    sha256 "99a07275ad62b9d26bf2e31ce5f4e0d9e35525a18c1414ef7d655c11a92510f9" => :mavericks
    sha256 "d33acad77bacbbec3c602541b3e0410576efda95679760314b7e5ba737154871" => :mountain_lion
  end

  depends_on :xcode => :build

  def install
    # 4.9 stable tarball has unexpected unpacked name, so go to the right
    # place.
    cd "platypus" if build.stable?

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
