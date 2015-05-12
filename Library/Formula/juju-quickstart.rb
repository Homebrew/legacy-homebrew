require "formula"

class JujuQuickstart < Formula
  homepage "https://launchpad.net/juju-quickstart"
  url "https://pypi.python.org/packages/source/j/juju-quickstart/juju-quickstart-2.1.0.tar.gz"
  sha1 "33f6b8abb157edffa802f7c756f1d78e607ad892"

  bottle do
    cellar :any
    sha256 "c5ffca2b77a5a2375cae07ce5b947b380155600d7f9f4b4e2c90094c9001c37e" => :yosemite
    sha256 "bcd29dbf01e04b48a1d976a5a0348e52aac4a242f6c2b675ae4c76ab724deb31" => :mavericks
    sha256 "3031583c25dd80d6c637c25819475dd2c000e190edb46949c3c2064a0b0e50ad" => :mountain_lion
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
