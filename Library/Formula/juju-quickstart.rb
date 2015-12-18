class JujuQuickstart < Formula
  desc "Opinionated command-line tool for quickly starting Juju"
  homepage "https://launchpad.net/juju-quickstart"
  url "https://pypi.python.org/packages/source/j/juju-quickstart/juju-quickstart-2.2.4.tar.gz"
  sha256 "fb01c8b48fe8b1e5d75ad3bc29527e78f5b4aadbe464b96e06ba15662a1edaac"

  bottle do
    cellar :any_skip_relocation
    sha256 "54876f96217375aed096768521b17d1e1c55ccc76aa729315e85b1b8bb6fed06" => :el_capitan
    sha256 "b1e05d648eb584df862dbc8d746c4074e905354aa5030e7a0049974d92ae982a" => :yosemite
    sha256 "de2e4731d9014c990db83b8bd608a2b720c36ab6ce9abe896f7b55b23c94aecd" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "juju"

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec+"lib/python2.7/site-packages"
    system "python", "setup.py", "install", "--prefix=#{libexec}"
    bin.install Dir[libexec/"bin/juju-quickstart"]
    bin.env_script_all_files(libexec+"bin", :PYTHONPATH => ENV["PYTHONPATH"])
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
