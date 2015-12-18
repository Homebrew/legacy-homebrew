class JujuQuickstart < Formula
  desc "Opinionated command-line tool for quickly starting Juju"
  homepage "https://launchpad.net/juju-quickstart"
  url "https://pypi.python.org/packages/source/j/juju-quickstart/juju-quickstart-2.2.4.tar.gz"
  sha256 "fb01c8b48fe8b1e5d75ad3bc29527e78f5b4aadbe464b96e06ba15662a1edaac"

  bottle do
    cellar :any_skip_relocation
    sha256 "a6dd9cb553b399995f36a076ffdb949f429a46a312bd9d8580ba28d3fe172b2a" => :el_capitan
    sha256 "55994b277c93c19b9534f56ac23c183ec0f27e7441609107e510f892e2e98c86" => :yosemite
    sha256 "b4c3a7b5d42d808bd96ec8b1a398e4d2950e1f5e3c0d1e00cfd259069e1191f5" => :mavericks
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
