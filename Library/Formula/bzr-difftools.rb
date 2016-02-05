class BzrDifftools < Formula
  desc "External diff support for Bazaar"
  homepage "https://launchpad.net/bzr-difftools"
  url "https://github.com/fmccann/bzr-difftools/archive/1.0.tar.gz"
  sha256 "4b4aadb7b8d3e33d4d09cb9ec1861933b1d6cfe631761429667bdde71072cc48"

  depends_on "bazaar"

  def install
    (share/"bazaar/plugins/difftools").install Dir["*"]
  end

  test do
    assert_match /plugin "difftools"/, shell_output("bzr help diff")
  end
end
