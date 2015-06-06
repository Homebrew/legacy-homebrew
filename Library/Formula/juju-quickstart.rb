require "formula"

class JujuQuickstart < Formula
  desc "Opinionated command-line tool for quickly starting Juju"
  homepage "https://launchpad.net/juju-quickstart"
  url "https://pypi.python.org/packages/source/j/juju-quickstart/juju-quickstart-2.1.1.tar.gz"
  sha1 "7743605cba0c41bab940ac9c03485ef087627327"

  bottle do
    cellar :any
    sha256 "64d5635334ba57d779cbb05c22d4d36a4f370c2646f99026965c9f76fcb76578" => :yosemite
    sha256 "2da3ac38839984c23513a110626fc9c6dc683097c99d1a538385e9d18d8683ca" => :mavericks
    sha256 "a89ce08340e0522a8f8a26b024c7797a245405867861c23d63c2f16968cb00d7" => :mountain_lion
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
