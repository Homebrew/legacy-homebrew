class BzrExplorer < Formula
  desc "Desktop application for using the Bazaar Version Control System"
  homepage "https://launchpad.net/bzr-explorer"
  url "https://launchpad.net/bzr-explorer/1.3/1.3.0/+download/bzr-explorer-1.3.0.tar.gz"
  sha256 "e3584df263a5004765a224cc38d00449e0ad47495070edae59ecbcc4dac94086"

  depends_on "bazaar"
  depends_on "qbzr"

  def install
    (share/"bazaar/plugins/explorer").install Dir["*"]
  end

  test do
    assert_match /Desktop application for Bazaar/, shell_output("bzr help explorer")
  end
end
