class BzrExplorer < Formula
  desc "Desktop application for using the Bazaar Version Control System"
  homepage "https://launchpad.net/bzr-explorer"
  url "https://launchpad.net/bzr-explorer/1.3/1.3.0/+download/bzr-explorer-1.3.0.tar.gz"
  sha256 "e3584df263a5004765a224cc38d00449e0ad47495070edae59ecbcc4dac94086"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa5fb7b5f5e4bd59218768e5edcdd1d1885c1660325410824dfe4dd2fe7d09ea" => :el_capitan
    sha256 "da20c1601c723ed76c2ed821f6f5227410a1b94404f693c356c4249e1d12c083" => :yosemite
    sha256 "70df82f8ac0c72265b2be43d3663e83ad5d34b839dc10706a6fd21806eb4539d" => :mavericks
  end

  depends_on "gettext" => :build
  depends_on "bazaar"
  depends_on "qbzr"

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
