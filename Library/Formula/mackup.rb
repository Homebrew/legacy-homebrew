class Mackup < Formula
  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://pypi.python.org/packages/source/m/mackup/mackup-0.8.8.tar.gz"
  sha256 "26a71b56e68690a64a9a114012411e3ca50560f5af661fbe8ccc944ac70441de"

  head "https://github.com/lra/mackup.git"

  bottle do
    cellar :any
    sha256 "13bdddd9a156847817efc6a300c86b9484e4589b015dbfe0356864c1a1a4ad64" => :yosemite
    sha256 "95ff3c6e6008a9114e38749bea86f4421ff008dce795910ea7a3c35d3f53495e" => :mavericks
    sha256 "f388306527e33ae6994db60c9157a576bbac8830ced202248bfe24f503ac8c64" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    %w[docopt].each do |r|
      resource(r).stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/mackup", "--help"
  end
end
