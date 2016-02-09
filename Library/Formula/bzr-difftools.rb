class BzrDifftools < Formula
  desc "External diff support for Bazaar"
  homepage "https://launchpad.net/bzr-difftools"
  url "lp:bzr-difftools", :using => :bzr
  version '0.0.1'

  depends_on "bazaar"

  def install
    (share/"bazaar/plugins/difftools").install Dir["*"]
  end

  test do
    assert_match /plugin "difftools"/, shell_output("bzr help diff")
  end
end
