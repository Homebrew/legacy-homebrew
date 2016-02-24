class SpacemanDiff < Formula
  desc "Diff images from the command-line"
  homepage "https://github.com/holman/spaceman-diff"
  url "https://github.com/holman/spaceman-diff/archive/1.0.2.tar.gz"
  sha256 "aae3d16d5c486c34127ac836cfb6d30ab45c9dea4c66212a412f7aab83eb6da2"

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
