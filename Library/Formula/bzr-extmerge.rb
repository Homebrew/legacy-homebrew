class BzrExtmerge < Formula
  desc "External merge tool support for Bazaar"
  homepage "https://launchpad.net/bzr-extmerge"
  url "lp:bzr-extmerge", :using => :bzr
  version '0.0.1'

  depends_on "bazaar"

  def install
    (share/"bazaar/plugins/extmerge").install Dir["*"]
  end

  test do
    assert_match /Calls an external merge program/, shell_output("bzr help extmerge")
  end
end
