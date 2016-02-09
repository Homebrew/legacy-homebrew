class Bzrtools < Formula
  desc "Bazaar plugin that supplies useful additional utilities"
  homepage "https://launchpad.net/bzrtools"
  url "lp:bzrtools", :using => :bzr, :tag => "release-2.3.0"

  depends_on "bazaar"

  def install
    (share/"bazaar/plugins/bzrtools").install Dir["*"]
  end

  test do
    assert_match /Various useful commands for working with bzr/, shell_output("bzr help bzrtools")
  end
end
