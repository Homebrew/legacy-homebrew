require "formula"

class JujuQuickstart < Formula
  homepage "https://launchpad.net/juju-quickstart"
  url "https://pypi.python.org/packages/source/j/juju-quickstart/juju-quickstart-2.0.0.tar.gz"
  sha1 "5ae0f94b87b03405a09413a55317f42ed112f725"

  bottle do
    cellar :any
    sha1 "eab34d08d71330b19814a20b0ec49a6597f187f9" => :yosemite
    sha1 "9dd2a594842c64152fd8dedc77949c856900469c" => :mavericks
    sha1 "42c8e1d8f8910969adecbb9539541a9d1b31d714" => :mountain_lion
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
