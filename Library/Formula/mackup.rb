require "formula"

class Mackup < Formula
  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://pypi.python.org/packages/source/m/mackup/mackup-0.8.6.tar.gz"
  sha256 "a011d85ec8f83e8219b103f101e5c4670b49c2c08e6bc478cb6a828a041bfe64"

  head "https://github.com/lra/mackup.git"

  bottle do
    cellar :any
    sha256 "a8090beac29eaf4bf0c1fafd51b3e951f172b0861d1ea53d58142ba73b9238a2" => :yosemite
    sha256 "9146ff2dab3d0b6da260570c84abe531d9d4f23c568d593fb79429629b3892e0" => :mavericks
    sha256 "3fc98483934fd83caec5ae740a3ccf347a9c2dfac4bf3b62893fb72fec30925d" => :mountain_lion
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
