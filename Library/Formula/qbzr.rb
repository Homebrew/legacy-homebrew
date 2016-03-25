class Qbzr < Formula
  desc "Simple Qt cross-platform frontend for some of Bazaar commands"
  homepage "https://launchpad.net/qbzr"
  url "https://launchpad.net/qbzr/0.23/0.23.1/+download/qbzr-0.23.1.tar.gz"
  sha256 "3211adef11c975dfbb6c80285651e2e6f3bfa99f1baa1a95371e8490ea8ff441"

  bottle :unneeded

  depends_on "bazaar"
  depends_on "pyqt"

  def install
    (share/"bazaar/plugins/qbzr").install Dir["*"]
  end

  def caveats; <<-EOS.undent
    In order to use this plugin you must set your PYTHONPATH in your ~/.bashrc:
    export PYTHONPATH="#{HOMEBREW_PREFIX}/lib/python2.7/site-packages:$PYTHONPATH"
  EOS
  end

  test do
    assert_match /qbzr #{version}/, shell_output("bzr plugins")
  end
end
