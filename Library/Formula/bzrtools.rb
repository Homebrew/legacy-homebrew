class Bzrtools < Formula
  desc "Bazaar plugin that supplies useful additional utilities"
  homepage "https://launchpad.net/bzrtools"
  url "https://launchpad.net/bzrtools/trunk/2.3.0/+download/bzrtools-2.3.0.tar.gz"
  sha256 "706270db274cdb4897eda1b8bb412383c71f6d1b3fac6ae3db587ac249ad5b79"

  depends_on "bazaar"

  def install
    (share/"bazaar/plugins/bzrtools").install Dir["*"]
  end

  test do
    assert_match /Various useful commands for working with bzr/, shell_output("bzr help bzrtools")
  end
end
