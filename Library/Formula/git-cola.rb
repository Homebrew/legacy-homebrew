class GitCola < Formula
  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://github.com/git-cola/git-cola/archive/v2.4.tar.gz"
  sha256 "ef735431a2e58bac7671c4b9ab4fbb369195b16987fe9d3d931a9097c06c7f36"
  head "https://github.com/git-cola/git-cola.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1d9b0f0b7df97b5e37fdf2b548f297aca05d303b4b27e66a81bd2972a9164163" => :el_capitan
    sha256 "0e307cb96047b9448bc531188fb8f44831074647a95819d5de76c59b4c4fb9fa" => :yosemite
    sha256 "3c1cde2b3b70661603f9eb94d3d0560ceaf27b11b98edb2b68b3bf524c444751" => :mavericks
  end

  option "with-docs", "Build manpages and HTML docs"

  depends_on "pyqt"

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

  resource "Pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
    sha256 "7320919084e6dac8f4540638a46447a3bd730fca172afc17d2c03eed22cf4f51"
  end

  resource "snowballstemmer" do
    url "https://pypi.python.org/packages/source/s/snowballstemmer/snowballstemmer-1.2.0.tar.gz"
    sha256 "6d54f350e7a0e48903a4e3b6b2cabd1b43e23765fbc975065402893692954191"
  end

  resource "Sphinx" do
    url "https://pypi.python.org/packages/source/S/Sphinx/Sphinx-1.3.1.tar.gz"
    sha256 "1a6e5130c2b42d2de301693c299f78cc4bd3501e78b610c08e45efc70e2b5114"
  end

  resource "sphinx_rtd_theme" do
    url "https://pypi.python.org/packages/source/s/sphinx_rtd_theme/sphinx_rtd_theme-0.1.9.tar.gz"
    sha256 "273846f8aacac32bf9542365a593b495b68d8035c2e382c9ccedcac387c9a0a1"
  end

  def install
    system "make", "prefix=#{prefix}", "install"

    if build.with? "docs"
      ENV.prepend_create_path "PYTHONPATH", buildpath/"sphinx/lib/python2.7/site-packages"
      resources.each do |r|
        r.stage { system "python", *Language::Python.setup_install_args(buildpath/"sphinx") }
      end
      system "make", "install-doc", "prefix=#{prefix}",
             "SPHINXBUILD=#{buildpath}/sphinx/bin/sphinx-build"
    end
  end

  test do
    system "#{bin}/git-cola", "--version"
  end
end
