class BzrXmloutput < Formula
  desc "Bazaar plugin that provides a option to generate XML output for builtins commands"
  homepage "https://launchpad.net/bzr-xmloutput"
  url "lp:bzr-xmloutput", :using => :bzr, :tag => "release-0.8.8"

  def install
    (share/"bazaar/plugins/xmloutput").install Dir["*"]
  end

  test do
    assert_match /xmloutput 0\.8\.8/, shell_output("bzr plugins")
  end
end
