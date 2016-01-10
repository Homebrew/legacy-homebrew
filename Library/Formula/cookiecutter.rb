class Cookiecutter < Formula
  desc "Utility that creates projects from templates"
  homepage "https://github.com/audreyr/cookiecutter"
  url "https://pypi.python.org/packages/source/c/cookiecutter/cookiecutter-1.3.0.tar.gz"
  sha256 "80723bf1aeac1bec673df71c5372a9c470ba720592d3340a8c1285c3f5ecf669"
  head "https://github.com/audreyr/cookiecutter.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b0bb020ba08b238feadc4c39c65319e80626eccd152c19744b30ee3232b3aeeb" => :el_capitan
    sha256 "5fd3b8dcdd06f9e0cda10367bcafb2f3977df4a0f6602f45345b83e09afe0b80" => :yosemite
    sha256 "73c7927254d144077df285fe7ca2212999ab92fd19cf997cbb4f08692fc21fa0" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "binaryornot" do
    url "https://pypi.python.org/packages/source/b/binaryornot/binaryornot-0.4.0.tar.gz"
    sha256 "ab0f387b28912ac9c300db843461359e2773da3b922ae378ab69b0d85b288ec8"
  end

  resource "chardet" do
    url "https://pypi.python.org/packages/source/c/chardet/chardet-2.3.0.tar.gz"
    sha256 "e53e38b3a4afe6d1132de62b7400a4ac363452dc5dfcf8d88e8e0cce663c68aa"
  end

  resource "click" do
    url "https://pypi.python.org/packages/source/c/click/click-5.1.tar.gz"
    sha256 "678c98275431fad324275dec63791e4a17558b40e5a110e20a82866139a85a5a"
  end

  resource "future" do
    url "https://pypi.python.org/packages/source/f/future/future-0.15.2.tar.gz"
    sha256 "3d3b193f20ca62ba7d8782589922878820d0a023b885882deec830adbf639b97"
  end

  resource "Jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "MarkupSafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "PyYAML" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha256 "c36c938a872e5ff494938b33b14aaa156cb439ec67548fcab3535bb78b0846e8"
  end

  resource "ruamel.yaml" do
    url "https://pypi.python.org/packages/source/r/ruamel.yaml/ruamel.yaml-0.10.12.tar.gz"
    sha256 "2bfd7d00c0ca859dbf1a7abca79969eedd25c76a976b7d40f94e1891a6e73f2c"
  end

  resource "ruamel.base" do
      url "https://pypi.python.org/packages/source/r/ruamel.base/ruamel.base-1.0.0.tar.gz"
      sha256 "c041333a0f0f00cd6593eb36aa83abb1a9e7544e83ba7a42aa7ac7476cee5cf3"
  end

  resource "ruamel.ordereddict" do
      url "https://pypi.python.org/packages/source/r/ruamel.ordereddict/ruamel.ordereddict-0.4.9.tar.gz"
      sha256 "7058c470f131487a3039fb9536dda9dd17004a7581bdeeafa836269a36a2b3f6"
  end

  resource "whichcraft" do
    url "https://pypi.python.org/packages/source/w/whichcraft/whichcraft-0.1.1.tar.gz"
    sha256 "5df20674e0a90028b5633417510f0001b63bc0f345ab3cbb184dd4b221d125ec"
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
    assert (testpath/"python_boilerplate").directory?
  end
end
