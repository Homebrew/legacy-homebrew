class Mackup < Formula
  desc "Keep your Mac's application settings in sync"
  homepage "https://github.com/lra/mackup"
  url "https://github.com/lra/mackup/archive/0.8.11.tar.gz"
  sha256 "a95ba796d4325ffc32f677a101972bfda18514ce0a3d629fa946e9165b8e1c28"

  head "https://github.com/lra/mackup.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "92b749f52ce8d6c148b4265b39691c0b7597397297438884af10f7e0544d83a3" => :el_capitan
    sha256 "ebc86d8c0fdc58def45abd2959378b4691a51460017133dd45021d220a1bd01e" => :yosemite
    sha256 "66597cadc051443b2d1346ff3ca21b2525b51b8525072d9890d3ae72297fe0b0" => :mavericks
    sha256 "dc88033695310bf4af0fa0a1fe586fc54722e3511d63cd050a85fc25f932e5bd" => :mountain_lion
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
