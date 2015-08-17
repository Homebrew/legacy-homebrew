class Mackup < Formula
  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://github.com/lra/mackup/archive/0.8.10.tar.gz"
  sha256 "fa7f5f9600e33742f07a5288a4e3a7ef63690530b28870da12606fdadb5f8fc2"

  head "https://github.com/lra/mackup.git"

  bottle do
    cellar :any
    sha256 "9fd3f9f427a83fb31e87025e924398e2ffe3166a8d1a86fee1ba4fe9d3932d7d" => :yosemite
    sha256 "6b6dc57f02ccfe1c92a6b13f1c163d04a34aeeae973952c2ddd9b5f3e8aec9d5" => :mavericks
    sha256 "be5ac0d33abc40e6016cd0e91106d073c8ce7d52a496be3c688ec17556d0132e" => :mountain_lion
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
