class Cookiecutter < Formula
  homepage "https://github.com/audreyr/cookiecutter"
  url "https://pypi.python.org/packages/source/c/cookiecutter/cookiecutter-1.0.0.tar.gz"
  sha256 "ebe8bc662dce0a26effc2a0fb344e5006832aef4cedb9c6a950a1e0e3f3f41fb"
  head "https://github.com/audreyr/cookiecutter.git"

  bottle do
    cellar :any
    sha1 "c01d592a6fd8873145753ddba5378b4df95c5861" => :yosemite
    sha1 "b5cde887f1c4fdb9e61bffb7383060eac76d3706" => :mavericks
    sha1 "25d1f4a6b95dbd294734fb37f873a00fbeeecefb" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "binaryornot" do
    url "https://pypi.python.org/packages/source/b/binaryornot/binaryornot-0.3.0.tar.gz"
    sha256 "83bc656b147983da8755c7b1e1323825d29a318ee437f91d210b16b1ec8bacf4"
  end

  resource "MarkupSafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "Jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha256 "2e24ac5d004db5714976a04ac0e80c6df6e47e98c354cb2c0d82f8879d4f8fdb"
  end

  resource "mock" do
    url "https://pypi.python.org/packages/source/m/mock/mock-1.0.1.tar.gz"
    sha256 "b839dd2d9c117c701430c149956918a423a9863b48b09c90e30a6013e7d2f44f"
  end

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-3.3.tar.gz"
    sha256 "f79c8c04d7eb50071bcad67fd23f3c10fab6c72d56857adf848367806845d6e5"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage { system "python", *Language::Python.setup_install_args(libexec/"vendor") }
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "git", "clone", "https://github.com/audreyr/cookiecutter-pypackage.git"
    system bin/"cookiecutter", "--no-input", "cookiecutter-pypackage"
    assert (testpath/"boilerplate").directory?
  end
end
