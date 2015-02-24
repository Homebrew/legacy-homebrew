require "formula"

class JujuQuickstart < Formula
  homepage "https://launchpad.net/juju-quickstart"
  url "https://pypi.python.org/packages/source/j/juju-quickstart/juju-quickstart-1.6.0.tar.gz"
  sha1 "6631c560bc26b88c85e281df4fe4b5199884ae5a"

  bottle do
    cellar :any
    sha1 "02532ac90922862ee5bb032d9e2f0d6cfddb7318" => :yosemite
    sha1 "8d7bba8d560e3ef6b9d2bba898926df11821457c" => :mavericks
    sha1 "a2846403ff5571b67287eeac8f9ce9bd17714a32" => :mountain_lion
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
