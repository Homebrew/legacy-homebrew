require "formula"

class JujuQuickstart < Formula
  homepage "https://launchpad.net/juju-quickstart"
  url "https://pypi.python.org/packages/source/j/juju-quickstart/juju-quickstart-1.4.0.tar.gz"
  sha1 "9c87b10663fe3b3d8fe08d145163b2d90a8da475"

  bottle do
    cellar :any
    sha1 "d4d23590fb06e7c032e239eb73d37263beeaac31" => :mavericks
    sha1 "28e85ae87e71411fbccdfd7d07d5403393dffac6" => :mountain_lion
    sha1 "3fba353eec6245e35b3315ec3140085b839076a8" => :lion
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
