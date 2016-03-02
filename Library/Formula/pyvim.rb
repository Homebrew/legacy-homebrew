class Pyvim < Formula
  desc "Pure Python Vim clone"
  homepage "https://pypi.python.org/pypi/pyvim"
  url "https://pypi.python.org/packages/source/p/pyvim/pyvim-0.0.15.tar.gz"
  sha256 "60ed07d8bd668e3a56f4510c95289b0a60cc8c51a2049c1845f6ad4523d918b4"

  bottle do
    cellar :any_skip_relocation
    sha256 "fcea9e888f429a9a73f9dc6bb2ff32c7cc7611472917e4772c7c00b905d0b601" => :el_capitan
    sha256 "d0304e69bae47a478f4d67d8f956a86b75a26514be8a32d8db8493462d5b8f5e" => :yosemite
    sha256 "cb336a0de0525d41c388683d8274b2ecfdee007729dc854ca80abc18926089c3" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "ptpython" do
    url "https://pypi.python.org/packages/source/p/ptpython/ptpython-0.30.tar.gz"
    sha256 "50efef571dbfc12c2b33c0b9ac29407e380ffb9dda948a0650aa382588736e72"
  end

  resource "prompt_toolkit" do
    url "https://pypi.python.org/packages/source/p/prompt_toolkit/prompt_toolkit-0.59.tar.gz"
    sha256 "efbec5350b0f61d27253c60fb20683c546ef4e8cac2b27239e335a8444ce21f3"
  end

  resource "pyflakes" do
    url "https://pypi.python.org/packages/source/p/pyflakes/pyflakes-1.1.0.tar.gz"
    sha256 "e5f959931987e2be178781554b485d52342ec9f1b43f891d2dad07a691c7a89a"
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
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.1.2.tar.gz"
    sha256 "82fc63b161043db20cba034abd43fa4cc10f73db91099355fa0d04043b4593d2"
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
