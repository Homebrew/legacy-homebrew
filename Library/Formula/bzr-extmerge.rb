class BzrExtmerge < Formula
  desc "External merge tool support for Bazaar"
  homepage "https://launchpad.net/bzr-extmerge"
  url "https://launchpad.net/bzr-extmerge/trunk/1.0.0/+download/bzr-extmerge-1.0.0.tar.gz"
  sha256 "1b86d3a54fe669db19bc2a42a09eae52e449cc3ece8234377fd213e834f69cc0"

  bottle :unneeded

  depends_on "bazaar"

  def install
    (share/"bazaar/plugins/extmerge").install Dir["*"]
  end

  test do
    assert_match /Calls an external merge program/, shell_output("bzr help extmerge")
  end
end
