class SphinxDoc < Formula
  desc "Tool to create intelligent and beautiful documentation"
  homepage "http://sphinx-doc.org"
  url "https://pypi.python.org/packages/source/S/Sphinx/Sphinx-1.3.1.tar.gz"
  sha256 "1a6e5130c2b42d2de301693c299f78cc4bd3501e78b610c08e45efc70e2b5114"

  bottle do
    cellar :any_skip_relocation
    sha256 "ef7eadc82631f678426bcd7810697833b1ade955e87d078a57ba8fd3804eb6c1" => :el_capitan
    sha256 "bddc4767fc0e7f8c13cbdad6d31820d4c17a7425aa4eab258eeb90928482e392" => :yosemite
    sha256 "1909df10b3644145eff9bd1770ec6110427133704f4044176d90470b444becfe" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  keg_only <<-EOS.undent
    This formula is mainly used internally by other formulae.
    Users are advised to use `pip` to install sphinx-doc.
  EOS

  resource "alabaster" do
    url "https://pypi.python.org/packages/source/a/alabaster/alabaster-0.7.6.tar.gz"
    sha256 "309d33e0282c8209f792f3527f41ec04e508ff837c61fc1906dde988a256deeb"
  end

  resource "Babel" do
    url "https://pypi.python.org/packages/source/B/Babel/Babel-2.1.1.tar.gz"
    sha256 "7fb6d50effe88a087feb2036cb972fd7a893bf338361516f1a55a820bf7b5248"
  end

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  resource "Jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "MarkupSafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "Pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
    sha256 "7320919084e6dac8f4540638a46447a3bd730fca172afc17d2c03eed22cf4f51"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2015.7.tar.bz2"
    sha256 "fbd26746772c24cb93c8b97cbdad5cb9e46c86bbdb1b9d8a743ee00e2fb1fc5d"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  resource "snowballstemmer" do
    url "https://pypi.python.org/packages/source/s/snowballstemmer/snowballstemmer-1.2.0.tar.gz"
    sha256 "6d54f350e7a0e48903a4e3b6b2cabd1b43e23765fbc975065402893692954191"
  end

  resource "sphinx_rtd_theme" do
    url "https://pypi.python.org/packages/source/s/sphinx_rtd_theme/sphinx_rtd_theme-0.1.9.tar.gz"
    sha256 "273846f8aacac32bf9542365a593b495b68d8035c2e382c9ccedcac387c9a0a1"
  end

  def install
    ENV.prepend_create_path "PYTHONPATH", libexec/"vendor/lib/python2.7/site-packages"
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec/"vendor")
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)

    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system bin/"sphinx-quickstart", "-pPorject", "-aAuthor", "-v1.0", "-q"
    system bin/"sphinx-build", testpath, testpath/"build"
    assert File.exist?("build/index.html")
  end
end
