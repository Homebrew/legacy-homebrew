class Pyvim < Formula
  desc "Pure Python Vim clone"
  homepage "https://pypi.python.org/pypi/pyvim"
  url "https://pypi.python.org/packages/source/p/pyvim/pyvim-0.0.16.tar.gz"
  sha256 "5c4b6fde5528845cf9a10267a6d598a24f2523d5b3ad451410860916cdf45378"

  bottle do
    cellar :any_skip_relocation
    sha256 "f56866a10ae2cc8f2fa529643bc3aba3e3162aef8ad6d37a746b0562468da9e9" => :el_capitan
    sha256 "950c402c841f90401de8fa888ec67108d55a48e9d8d79348d805f32632c146ae" => :yosemite
    sha256 "4c0ceb84de6253eb8b433ad38bcc15f8eaafff8f451ebc76ebbcc91ff796ea58" => :mavericks
  end

  depends_on :python if MacOS.version <= :snow_leopard

  resource "ptpython" do
    url "https://pypi.python.org/packages/source/p/ptpython/ptpython-0.31.tar.gz"
    sha256 "a70ac512efc7b3c3e1ed6adba56f7214d5ed48729f9dac474e9a73472152006f"
  end

  resource "prompt_toolkit" do
    url "https://pypi.python.org/packages/source/p/prompt_toolkit/prompt_toolkit-0.60.tar.gz"
    sha256 "b44acc4cf3fb9f7331343ae170eac06f853a66e28cdd4ccfeee7c8dad0dec33d"
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
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.1.3.tar.gz"
    sha256 "88e4c8a91b2af5962bfa5ea2447ec6dd357018e86e94c7d14bd8cacbc5b55d81"
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
