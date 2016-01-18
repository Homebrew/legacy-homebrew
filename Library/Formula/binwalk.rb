class Binwalk < Formula
  desc "Searches a binary image for embedded files and executable code"
  homepage "http://binwalk.org/"
  url "https://github.com/devttys0/binwalk/archive/v2.1.1.tar.gz"
  sha256 "1b70a5b03489d29f60fef18008a2164974234874faab48a4f47ec53d461d284a"
  head "https://github.com/devttys0/binwalk.git"

  bottle do
    sha256 "7c45d823c2fc4eae924ebda88a59fa1ea793bbc43346816a48da9f87931a13ec" => :el_capitan
    sha256 "764a4275eb3ffa1317cdb9d38a9af75490717fb5eb0efd84b3968a11443a1a1e" => :yosemite
    sha256 "8b5210a335b36d32040061b611ad122828877a7df8138dc544c566b16542fcee" => :mavericks
  end

  option "with-matplotlib", "Check for presence of matplotlib, which is required for entropy graphing support"
  option "with-capstone", "Enable disasm options via capstone"

  depends_on "swig" => :build
  depends_on :fortran
  depends_on "matplotlib" => :python if build.with? "matplotlib"
  depends_on "pyside"
  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "p7zip"
  depends_on "ssdeep"
  depends_on "xz"

  resource "pyqtgraph" do
    url "http://www.pyqtgraph.org/downloads/pyqtgraph-0.9.10.tar.gz"
    sha256 "4c0589774e3c8b0c374931397cf6356b9cc99a790215d1917bb7f015c6f0729a"
  end

  resource "numpy" do
    url "https://pypi.python.org/packages/source/n/numpy/numpy-1.10.2.tar.gz"
    sha256 "23a3befdf955db4d616f8bb77b324680a80a323e0c42a7e8d7388ef578d8ffa9"
  end

  resource "scipy" do
    url "https://downloads.sourceforge.net/project/scipy/scipy/0.16.1/scipy-0.16.1.tar.gz"
    sha256 "ecd1efbb1c038accb0516151d1e6679809c6010288765eb5da6051550bf52260"
  end

  resource "capstone" do
    url "https://pypi.python.org/packages/source/c/capstone/capstone-3.0.4.tar.gz"
    sha256 "945d3b8c3646a1c3914824c416439e2cf2df8969dd722c8979cdcc23b40ad225"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    res = %w[numpy scipy pyqtgraph]
    res += %w[capstone] if build.with? "capstone"
    res.each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir["#{libexec}/bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    touch "binwalk.test"
    system "#{bin}/binwalk", "binwalk.test"
  end
end
