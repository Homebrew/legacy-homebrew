class BzrBisect < Formula
  desc "Binary search for Bazaar"
  homepage "https://launchpad.net/bzr-bisect"
  url "https://github.com/fmccann/bzr-bisect/archive/1.0.tar.gz"
  sha256 "5f35a19415c95f857614dab7761afcdb0103fe0535c4399082932c195deae36c"

  depends_on "bazaar"

  def install
    (share/"bazaar/plugins/bisect").install Dir["*"]
  end

  test do
    assert_match /Find an interesting commit using a binary search/, shell_output("bzr help bisect")
  end
end
