class Pyvim < Formula
  desc "Pure Python Vim clone"
  homepage "https://pypi.python.org/pypi/pyvim"
  url "https://pypi.python.org/packages/source/p/pyvim/pyvim-0.0.13.tar.gz"
  sha256 "efc4054d2fae78df13182ad78e018d479963833a990d7e99d58ee4fe2db2c1cd"

  bottle do
    cellar :any_skip_relocation
    sha256 "fcea9e888f429a9a73f9dc6bb2ff32c7cc7611472917e4772c7c00b905d0b601" => :el_capitan
    sha256 "d0304e69bae47a478f4d67d8f956a86b75a26514be8a32d8db8493462d5b8f5e" => :yosemite
    sha256 "cb336a0de0525d41c388683d8274b2ecfdee007729dc854ca80abc18926089c3" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "ptpython" do
    url "https://pypi.python.org/packages/source/p/ptpython/ptpython-0.28.tar.gz"
    sha256 "f4bc7c4b129925be316c60669b5c0a5cc97edc0fb381fd007aa0ecc81758ee1d"
  end

  resource "prompt_toolkit" do
    url "https://pypi.python.org/packages/source/p/prompt_toolkit/prompt_toolkit-0.57.tar.gz"
    sha256 "de6019e1ebe99647d1b6640f09a02961b26144a91d9964ed93a41ccada9a9fae"
  end

  resource "pyflakes" do
    url "https://pypi.python.org/packages/source/p/pyflakes/pyflakes-1.0.0.tar.gz"
    sha256 "f39e33a4c03beead8774f005bd3ecf0c3f2f264fa0201de965fce0aff1d34263"
  end

  resource "docopt" do
    url "https://pypi.python.org/packages/source/d/docopt/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "jedi" do
    url "https://pypi.python.org/packages/source/j/jedi/jedi-0.9.0.tar.gz"
    sha256 "3b4c19fba31bdead9ab7350fb9fa7c914c59b0a807dcdd5c00a05feb85491d31"
  end

  resource "wcwidth" do
    url "https://pypi.python.org/packages/source/w/wcwidth/wcwidth-0.1.6.tar.gz"
    sha256 "dcb3ec4771066cc15cf6aab5d5c4a499a5f01c677ff5aeb46cf20500dccd920b"
  end

  resource "pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.1.tar.gz"
    sha256 "13a0ef5fafd7b16cf995bc28fe7aab0780dab1b2fda0fc89e033709af8b8a47b"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.10.0.tar.gz"
    sha256 "105f8d68616f8248e24bf0e9372ef04d3cc10104f1980f54d57b2ce73a5ad56a"
  end

  def install
    resources.each do |r|
      r.stage do
        system "python", *Language::Python.setup_install_args(libexec)
      end
    end

    ENV.prepend_create_path "PYTHONPATH", libexec/"lib/python2.7/site-packages"
    system "python", *Language::Python.setup_install_args(libexec)
    bin.install Dir[libexec/"bin/*"]
    bin.env_script_all_files(libexec/"bin", :PYTHONPATH => ENV["PYTHONPATH"])
  end

  test do
    system "#{bin}/pyvim", "--help"
  end
end
