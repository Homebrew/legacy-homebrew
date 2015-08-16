class Mackup < Formula
  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://github.com/lra/mackup/archive/0.8.10.tar.gz"
  sha256 "fa7f5f9600e33742f07a5288a4e3a7ef63690530b28870da12606fdadb5f8fc2"

  head "https://github.com/lra/mackup.git"

  bottle do
    cellar :any
    sha256 "a9475c446193be3437ebad1311e3bab3fac37537a32e93a1360e487f565dc4b5" => :yosemite
    sha256 "8b1ab55afb72c546a7199ff0ce41113dbf703101dbcfab7dc22c9c42dcc3aa18" => :mavericks
    sha256 "e8a2d717761fc3bb807c5926c757f7343e9d2d612bb04e42b1402b7722d76e97" => :mountain_lion
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
