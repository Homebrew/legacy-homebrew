require "formula"

class JujuQuickstart < Formula
  desc "Opinionated command-line tool for quickly starting Juju"
  homepage "https://launchpad.net/juju-quickstart"
  url "https://pypi.python.org/packages/source/j/juju-quickstart/juju-quickstart-2.2.0.tar.gz"
  sha1 "4f009d463cb4249a0b9e5c1201d910186321c12e"

  bottle do
    cellar :any
    sha256 "f6a3b86834ac7f5d8523ff1070bcb4cc6893c6c6e050aa90b27b99f458b12789" => :yosemite
    sha256 "06decd0e63754e9fd0aaaa5dbb0dad56d372d1fad9ccac81f34dee0a2c1b39f0" => :mavericks
    sha256 "582c7d89b1584bd06a984f5f84babf667c2bef654c446e0d0ae8319b678df896" => :mountain_lion
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
