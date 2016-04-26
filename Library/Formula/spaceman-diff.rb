class SpacemanDiff < Formula
  desc "Diff images from the command-line"
  homepage "https://github.com/holman/spaceman-diff"
  url "https://github.com/holman/spaceman-diff/archive/v1.0.3.tar.gz"
  sha256 "347bf7d32d6c2905f865b90c5e6f4ee2cd043159b61020381f49639ed5750fdf"

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
