class SpacemanDiff < Formula
  desc "Diff images from the command-line"
  homepage "https://github.com/holman/spaceman-diff"
  url "https://github.com/holman/spaceman-diff/archive/v1.0.1.tar.gz"
  sha256 "98c9420eb769914837e97f4f369523b42c6eb8141175f97cbd7cadf2d3609ede"

  head "https://github.com/holman/spaceman-diff.git"

  bottle :unneeded

  depends_on "jp2a"
  depends_on "imagemagick"

  def install
    bin.install "spaceman-diff"
  end

  test do
    output = shell_output("#{bin}/spaceman-diff")
    assert_match /USAGE/, output

    png = test_fixtures("test.png")
    system "script", "-q", "/dev/null", "#{bin}/spaceman-diff", png, "a190ba", "100644", png, "000000", "100644"
  end
end
