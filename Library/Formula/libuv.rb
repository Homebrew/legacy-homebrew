class Libuv < Formula
  desc "Platform layer for Node.js"
  homepage "https://github.com/libuv/libuv"
  url "https://github.com/libuv/libuv/archive/v1.6.1.tar.gz"
  sha256 "f558ede285878d6a69f6a6d43b5df0241f3c35d62ac989477bdbd418badd83d7"
  head "https://github.com/libuv/libuv.git", :branch => "v1.x"

  bottle do
    cellar :any
    sha256 "41a2ffe18121ad982123e9d87289738ac107627b3ddbcfd161d33b0e3e967270" => :yosemite
    sha256 "27588272130bbd2a88758563567a5d3f2e714baa3404578326dcc77c28dcebf5" => :mavericks
    sha256 "89e3307c8a4d180840f76f27129048d4f79cfd98d9035b7187f166cbfd174a21" => :mountain_lion
  end

  option "without-docs", "Don't build and install documentation"
  option :universal

  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on "libtool" => :build
  depends_on :python => :build if MacOS.version <= :snow_leopard && build.with?("docs")

  resource "sphinx" do
    url "https://pypi.python.org/packages/source/S/Sphinx/Sphinx-1.3.1.tar.gz"
    sha256 "1a6e5130c2b42d2de301693c299f78cc4bd3501e78b610c08e45efc70e2b5114"
  end

  resource "sphinx_rtd_theme" do
    url "https://pypi.python.org/packages/source/s/sphinx_rtd_theme/sphinx_rtd_theme-0.1.7.tar.gz"
    sha256 "9a490c861f6cf96a0050c29a92d5d1e01eda02ae6f50760ad5c96a327cdf14e8"
  end

  resource "alabaster" do
    url "https://pypi.python.org/packages/source/a/alabaster/alabaster-0.7.4.tar.gz"
    sha256 "ce77e2fdbaabaae393ffce2a6252a0a666e3977c6c2fa1c48c4ded0569785951"
  end

  resource "babel" do
    url "https://pypi.python.org/packages/source/B/Babel/Babel-1.3.tar.gz"
    sha256 "9f02d0357184de1f093c10012b52e7454a1008be6a5c185ab7a3307aceb1d12e"
  end

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  resource "pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
    sha256 "7320919084e6dac8f4540638a46447a3bd730fca172afc17d2c03eed22cf4f51"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha256 "2e24ac5d004db5714976a04ac0e80c6df6e47e98c354cb2c0d82f8879d4f8fdb"
  end

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "snowballstemmer" do
    url "https://pypi.python.org/packages/source/s/snowballstemmer/snowballstemmer-1.2.0.tar.gz"
    sha256 "6d54f350e7a0e48903a4e3b6b2cabd1b43e23765fbc975065402893692954191"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2015.4.tar.bz2"
    sha256 "a78b484d5472dd8c688f8b3eee18646a25c66ce45b2c26652850f6af9ce52b17"
  end

  def install
    ENV.universal_binary if build.universal?

    if build.with? "docs"
      ENV.prepend_create_path "PYTHONPATH", buildpath/"sphinx/lib/python2.7/site-packages"
      resources.each do |r|
        r.stage do
          system "python", *Language::Python.setup_install_args(buildpath/"sphinx")
        end
      end
      ENV.prepend_path "PATH", (buildpath/"sphinx/bin")
      # This isn't yet handled by the make install process sadly.
      cd "docs" do
        system "make", "man"
        system "make", "singlehtml"
        man1.install "build/man/libuv.1"
        doc.install Dir["build/singlehtml/*"]
      end
    end

    # Don't add "make check" until this is resolved upstream:
    # https://github.com/Homebrew/homebrew/issues/38138
    # https://github.com/libuv/libuv/issues/30
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <uv.h>

      int main()
      {
        uv_loop_t* loop = malloc(sizeof *loop);
        uv_loop_init(loop);
        uv_loop_close(loop);
        free(loop);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-luv", "-o", "test"
    system "./test"
  end
end
