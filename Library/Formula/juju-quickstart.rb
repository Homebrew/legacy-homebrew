require "formula"

class JujuQuickstart < Formula
  homepage "https://launchpad.net/juju-quickstart"
  url "https://pypi.python.org/packages/source/j/juju-quickstart/juju-quickstart-1.4.1.tar.gz"
  sha1 "8a76cedd7c1025c4b4bd245eefe78794bc89d42a"

  bottle do
    cellar :any
    sha1 "9182059dfd2eaa217519ea219ec31b2803fdafda" => :mavericks
    sha1 "3e5728d42a4a740b643cff5b16f7bad51b65beb7" => :mountain_lion
    sha1 "bc834cb2e2761a8be4754fc2e48e9b82d33f5050" => :lion
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
