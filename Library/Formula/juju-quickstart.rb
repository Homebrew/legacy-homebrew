class JujuQuickstart < Formula
  desc "Opinionated command-line tool for quickly starting Juju"
  homepage "https://launchpad.net/juju-quickstart"
  url "https://pypi.python.org/packages/source/j/juju-quickstart/juju-quickstart-2.2.2.tar.gz"
  sha256 "07eb4c53b9091a75fcef94eb243d42cd6b8c289f2763b0dbde462a2b602094c3"

  bottle do
    cellar :any_skip_relocation
    sha256 "c3a7ebf7e43b506b3f80af3be55dcb48a695e173b142a87281e621ec83c52484" => :el_capitan
    sha256 "d96836ff4ff4adf6d474a75f5407d7d93681ff06ffab5af0f215c12f5d19ea3c" => :yosemite
    sha256 "70b1633e51e76021c59dcf5f5af3b877b0f418271e8ffd24967f5351a9f1176e" => :mavericks
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
