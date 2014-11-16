require "formula"

class JujuQuickstart < Formula
  homepage "https://launchpad.net/juju-quickstart"
  url "https://pypi.python.org/packages/source/j/juju-quickstart/juju-quickstart-1.5.0.tar.gz"
  sha1 "05f27f0d62cd2f7a49f2584b965a78c4502cd4ac"

  bottle do
    cellar :any
    sha1 "31f0e8cd3c4e7a9d8076fe78a1c93184eb37a91a" => :yosemite
    sha1 "b5df56eb3553ac0ca416f36ee9d7acb48b4e5826" => :mavericks
    sha1 "d710ae76c5c80dd91b55e3b3e2efefd74306d0c2" => :mountain_lion
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
