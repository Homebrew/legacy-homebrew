require "formula"

class JujuQuickstart < Formula
  homepage "https://launchpad.net/juju-quickstart"
  url "https://pypi.python.org/packages/source/j/juju-quickstart/juju-quickstart-1.4.4.tar.gz"
  sha1 "33cbe5cd8258ec2a4a767cbf1bce8de8236ff1a5"

  bottle do
    cellar :any
    sha1 "6ff0ce98935349c8b9919a867687c0242a803ac4" => :mavericks
    sha1 "ca9c4d7b3ba3c1722586cccc3db05c24a362bccc" => :mountain_lion
    sha1 "3959e55903d7af18e956bba773041764917fba7c" => :lion
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
