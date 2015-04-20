require "formula"

class JujuQuickstart < Formula
  homepage "https://launchpad.net/juju-quickstart"
  url "https://pypi.python.org/packages/source/j/juju-quickstart/juju-quickstart-2.0.1.tar.gz"
  sha1 "603cf03a47e91d83f3d6032b99e0e7fdf07ecfcd"

  bottle do
    cellar :any
    sha256 "419bab189ed2bb0fdeb9af6968a7cb16372b7380c221f80c3f1419f2c6cbb090" => :yosemite
    sha256 "77192413d3fd484e0c53b294e5051b813e9654d6eca1ea6443dde8c0600b577a" => :mavericks
    sha256 "5b1cf409c5d3491d12f8c9ef2c4f0c40db93604e29048c0a29a803e36bcc8ac2" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "juju"

  def install
    ENV.prepend_create_path 'PYTHONPATH', libexec+'lib/python2.7/site-packages'
    system "python", "setup.py", "install", "--prefix=#{libexec}"
    bin.install Dir[libexec/'bin/juju-quickstart']
    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end

  test do
    # While a --version test is noted to be a "bad" test it does
    # exercise that most of the packages can be imported, so it is
    # better than nothing.  Can't really test the spinning up of Juju
    # environments on ec2 as part of installation, given that would
    # cost real money.
    system "#{bin}/juju-quickstart", "--version"
  end
end
