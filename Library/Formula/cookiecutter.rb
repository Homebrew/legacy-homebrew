class Cookiecutter < Formula
  homepage "https://github.com/audreyr/cookiecutter"
  url "https://pypi.python.org/packages/source/c/cookiecutter/cookiecutter-0.9.0.tar.gz"
  sha1 "2e9c483c66d1f32e9be67d38733d9b660a666cd7"
  head "https://github.com/audreyr/cookiecutter.git"

  bottle do
    cellar :any
    sha1 "9a22153459acc63e865edbf269f7f184fb4cee28" => :yosemite
    sha1 "b505e0d5d975be2a0b4ab2581cc2b57f46271fcc" => :mavericks
    sha1 "6a2268b6b188d28126d1ea9d2712b1b532b70464" => :mountain_lion
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "binaryornot" do
    url "https://pypi.python.org/packages/source/b/binaryornot/binaryornot-0.3.0.tar.gz"
    sha1 "97142e0d9f1fe77e86e6183510d5a4ca796349ad"
  end

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha1 "cd5c22acf6dd69046d6cb6a3920d84ea66bdf62a"
  end

  resource "pyyaml" do
    url "https://pypi.python.org/packages/source/P/PyYAML/PyYAML-3.11.tar.gz"
    sha1 "1a2d5df8b31124573efb9598ec6d54767f3c4cd4"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha1 "25ab3881f0c1adfcf79053b58de829c5ae65d3ac"
  end

  resource "mock" do
    url "https://pypi.python.org/packages/source/m/mock/mock-1.0.1.tar.gz"
    sha1 "ba2b1d5f84448497e14e25922c5e3293f0a91c7e"
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
    system "#{bin}/cookiecutter", "--help"
  end
end
