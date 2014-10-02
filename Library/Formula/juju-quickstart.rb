require "formula"

class JujuQuickstart < Formula
  homepage "https://launchpad.net/juju-quickstart"
  url "https://pypi.python.org/packages/source/j/juju-quickstart/juju-quickstart-1.4.4.tar.gz"
  sha1 "33cbe5cd8258ec2a4a767cbf1bce8de8236ff1a5"

  bottle do
    cellar :any
    sha1 "84b274cebe23f5c83a998d7471cb71dee584b848" => :mavericks
    sha1 "eecfe836a3db5a78fce3aed92d9eb4cb4df3481d" => :mountain_lion
    sha1 "caeb57899d90a605c06560c943d8535d70a8c8c9" => :lion
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
