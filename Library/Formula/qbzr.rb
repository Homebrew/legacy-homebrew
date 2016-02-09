class Qbzr < Formula
  desc "Simple Qt cross-platform frontend for some of Bazaar commands"
  homepage "https://launchpad.net/qbzr"
  url "lp:qbzr", :using => :bzr, :tag => "release-0.23.1"

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
    assert_match /QBzr - Qt-based frontend for Bazaar/, shell_output("bzr help qbzr")
  end
end
