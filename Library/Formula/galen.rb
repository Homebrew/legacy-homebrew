class Galen < Formula
  desc "Automated testing of look and feel for responsive websites"
  homepage "http://galenframework.com/"
  url "https://github.com/galenframework/galen/releases/download/galen-2.1.2/galen-bin-2.1.2.zip"
  sha256 "46c94af882845bca40168860f5ed35630a0b5416d18c37f479807da86c1c067e"

  bottle do
    cellar :any_skip_relocation
    sha256 "165f156f19df88826e595ca67e9ce144e3b64bd655bec4d334465d946fb73f59" => :el_capitan
    sha256 "3f968ded3798169d8199f5f9c635a70e063e113525d6e365c1bf3d7c7e75c56f" => :yosemite
    sha256 "3d1dc754b35a7e1d5c37518b33e3a7fc91e560da90d7df872afeadbcb67c7040" => :mavericks
  end

  depends_on :java => "1.6+"

  def install
    libexec.install "galen.jar"
    (bin/"galen").write <<-EOS.undent
      #!/bin/sh
      set -e
      java -cp "#{libexec}/galen.jar:lib/*:libs/*" com.galenframework.GalenMain "$@"
    EOS
  end

  test do
    assert_match "Version: #{version}", shell_output("#{bin}/galen -v")
  end
end
