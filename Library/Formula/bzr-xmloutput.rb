class BzrXmloutput < Formula
  desc "Bazaar plugin that provides a option to generate XML output for builtins commands"
  homepage "https://launchpad.net/bzr-xmloutput"
  url "https://launchpad.net/bzr-xmloutput/trunk/0.8.8/+download/bzr-xmloutput-0.8.8.tar.gz"
  sha256 "73b9b2f6ce4d9910031df7fd153d56d14f833c20a106f099bee5a33463f73b36"

  def install
    (share/"bazaar/plugins/xmloutput").install Dir["*"]
  end

  test do
    assert_match /xmloutput 0\.8\.8/, shell_output("bzr plugins")
  end
end
