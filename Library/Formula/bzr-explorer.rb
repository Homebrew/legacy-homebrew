class BzrExplorer < Formula
  desc "Desktop application for using the Bazaar Version Control System"
  homepage "https://launchpad.net/bzr-explorer"
  url "https://launchpad.net/bzr-explorer/1.3/1.3.0/+download/bzr-explorer-1.3.0.tar.gz"
  sha256 "e3584df263a5004765a224cc38d00449e0ad47495070edae59ecbcc4dac94086"

  depends_on "bazaar"
  depends_on "qbzr"
  depends_on "gettext" => :build

  def install
    system "make", "pot"
    system "make", "mo"
    (share/"bazaar/plugins/explorer").install Dir["*"]
  end

  def caveats; <<-EOS.undent
    In order to use this plugin you must set your PYTHONPATH in your ~/.bashrc:
    export PYTHONPATH="#{HOMEBREW_PREFIX}/lib/python2.7/site-packages:$PYTHONPATH"

  EOS
  end

  test do
    assert_match /explorer #{version}/, shell_output("bzr plugins")
  end
end
