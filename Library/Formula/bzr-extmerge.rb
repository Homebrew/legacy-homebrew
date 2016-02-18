class BzrExtmerge < Formula
  desc "External merge tool support for Bazaar"
  homepage "https://launchpad.net/bzr-extmerge"
  url "lp:bzr-extmerge", :using => :bzr, :revision => 'erik@plero.se-20100728145225-et6ipg7cjbshiz8f'

  bottle :unneeded

  depends_on "bazaar"

  def install
    (share/"bazaar/plugins/extmerge").install Dir["*"]
  end

  test do
    assert_match /Calls an external merge program/, shell_output("bzr help extmerge")
  end
end