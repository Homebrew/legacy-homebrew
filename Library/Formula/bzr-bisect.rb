class BzrBisect < Formula
  desc "Binary search for Bazaar"
  homepage "https://launchpad.net/bzr-bisect"
  url "lp:bzr-bisect", :using => :bzr
  version '0.0.1'

  depends_on "bazaar"

  def install
    (share/"bazaar/plugins/bisect").install Dir["*"]
  end

  test do
    assert_match /Find an interesting commit using a binary search/, shell_output("bzr help bisect")
  end
end
