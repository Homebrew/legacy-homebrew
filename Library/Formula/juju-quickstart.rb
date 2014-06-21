require "formula"

class JujuQuickstart < Formula
  homepage "https://launchpad.net/juju-quickstart"
  url "https://pypi.python.org/packages/source/j/juju-quickstart/juju-quickstart-1.4.0.tar.gz"
  sha1 "9c87b10663fe3b3d8fe08d145163b2d90a8da475"

  bottle do
    cellar :any
    sha1 "6673ec3b9a1dca8f7c564fd35e9fd58aa92a4316" => :mavericks
    sha1 "681d63bb59abb9777e4c36c77b98be6555621693" => :mountain_lion
    sha1 "c286570035f4916ddf802da85ea408b029180316" => :lion
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
