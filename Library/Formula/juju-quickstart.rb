class JujuQuickstart < Formula
  desc "Opinionated command-line tool for quickly starting Juju"
  homepage "https://launchpad.net/juju-quickstart"
  url "https://pypi.python.org/packages/source/j/juju-quickstart/juju-quickstart-2.2.1.tar.gz"
  sha256 "5e1bba8ae3caba89cb8e772bc944bb6362d82c560671929e6a523af27fc7e5c9"

  bottle do
    cellar :any
    sha256 "eb14552c0e67007efc2b46d4150e6c85dc149915d573fefcc67c183e5b837a34" => :yosemite
    sha256 "70deb77d00ece41d3f70d580e56356e333267a9e690b7d5f6854dc94cf372d53" => :mavericks
    sha256 "f6274e17584f6fee0995d3fcae372c6f63af8fc9c615533eb3d50da1b580548d" => :mountain_lion
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
