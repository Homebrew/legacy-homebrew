class Xtitle < Formula
  desc "Set window title and icon for your X terminal"
  homepage "https://www.cs.indiana.edu/~kinzler/xtitle/"
  url "https://www.cs.indiana.edu/~kinzler/xtitle/xtitle-1.0.4.tgz"
  sha256 "cadddef1389ba1c5e1dc7dd861545a5fe11cb397a3f692cd63881671340fcc15"

  bottle :unneeded

  def install
    bin.install "xtitle.sh" => "xtitle"
    bin.install "xtctl.sh" => "xtctl"
    man1.install "xtitle.man" => "xtitle.1"
  end

  test do
    assert_equal "#{version}", shell_output("#{bin}/xtitle -V").chomp
  end
end
