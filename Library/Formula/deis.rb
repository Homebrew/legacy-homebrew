class Deis < Formula
  desc "Deploy and manage applications on your own servers"
  homepage "http://deis.io"
  url "https://github.com/deis/deis/archive/v1.5.1.tar.gz"
  sha256 "9158f1678dfe6c3071c492007167800c23b6e3df988cea230babebb5406189f6"

  bottle do
    cellar :any
    sha256 "fec83c5afc3261b56fccb415ae89588b1cde6828a007af0495b22f7cfbc93195" => :yosemite
    sha256 "eb491d5b606955a10c0dfd916d61964e1a7b2447556b86b2928f977ba7036a0f" => :mavericks
    sha256 "e357da38990b1e9cfd4ee3ad9577b8fa2c0e029752b0705d0bcaf6b9a14d899a" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard
  depends_on "libyaml"

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "python-dateutil" do
    url "https://pypi.python.org/packages/source/p/python-dateutil/python-dateutil-2.4.1.post1.tar.gz"
    sha256 "aa9bdbd60c395db90204609f1fb5aeb3797870f65c09f04f243476d22f8f4615"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "requests" do
    url "https://pypi.python.org/packages/source/r/requests/requests-2.5.1.tar.gz"
    sha256 "7b7735efd3b1e2323dc9fcef060b380d05f5f18bd0f247f5e9e74a628279de66"
  end

  resource "termcolor" do
    url "https://pypi.python.org/packages/source/t/termcolor/termcolor-1.1.0.tar.gz"
    sha256 "1d6d69ce66211143803fbc56652b41d73b4a400a2891d7bf7a1cdf4c02de613b"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "tabulate" do
    url "https://pypi.python.org/packages/source/t/tabulate/tabulate-0.7.4.tar.gz"
    sha256 "6bcd5e47372cca82088f87dfe2f365f79965b2be7837e3bac5a75adf4e0b0ba8"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"

    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    cd "client" do
      ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
      system "python", *Language::Python.setup_install_args(libexec)
    end

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/deis", "logout"
  end
end
