class BzrExplorer < Formula
  desc "Desktop application for using the Bazaar Version Control System"
  homepage "https://launchpad.net/bzr-explorer"
  url "lp:bzr-explorer", :using => :bzr
  version '1.3.0'

  depends_on "bazaar"
  depends_on "qbzr"

  def install
    (share/"bazaar/plugins/explorer").install Dir["*"]
  end

  def caveats; <<-EOS.undent
    In order to use this plugin you must set your PYTHONPATH in your ~/.bashrc:

    export PYTHONPATH="#{HOMEBREW_PREFIX}/lib/python2.7/site-packages:$PYTHONPATH"

  EOS
  end

  test do
    assert_match /Desktop application for Bazaar/, shell_output("bzr help explorer")
  end
end
