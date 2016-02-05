class BzrExtmerge < Formula
  desc "External merge tool support for Bazaar"
  homepage "https://launchpad.net/bzr-extmerge"
  url "https://github.com/fmccann/bzr-extmerge/archive/1.0.tar.gz"
  sha256 "d95f33ae7526bd906452ef80ea8893d13f8bcec15678e2accff0288493b78c6f"

  depends_on "bazaar"

  def install
    (share/"bazaar/plugins/extmerge").install Dir["*"]
  end

  test do
    assert_match /Calls an external merge program/, shell_output("bzr help extmerge")
  end
end
