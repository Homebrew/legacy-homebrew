class Cmake < Formula
  desc "Cross-platform make"
  homepage "http://www.cmake.org/"
  url "http://www.cmake.org/files/v3.3/cmake-3.3.1.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/c/cmake/cmake_3.3.1.orig.tar.gz"
  sha256 "cd65022c6a0707f1c7112f99e9c981677fdd5518f7ddfa0f778d4cee7113e3d6"
  head "http://cmake.org/cmake.git"

  bottle do
    cellar :any
    revision 1
    sha256 "fe55506ba09b02d36f0af20fa769e515431a722985151f38201f578ecd45dcd4" => :yosemite
    sha256 "9a5060be50cac455398811938187148ee86b07fde2de979ff316ce470519aa86" => :mavericks
    sha256 "56c8b25e50060f6f221038a697d6ad23bdd1824c57d62531569702919cbba8de" => :mountain_lion
  end

  option "without-docs", "Don't build man pages"
  option "with-completion", "Install Bash completion (Has potential problems with system bash)"

  depends_on :python => :build if MacOS.version <= :snow_leopard && build.with?("docs")

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use brew install caskroom/cask/cmake.

  resource "sphinx_rtd_theme" do
    url "https://pypi.python.org/packages/source/s/sphinx_rtd_theme/sphinx_rtd_theme-0.1.8.tar.gz"
    sha256 "74f633ed3a61da1d1d59c3185483c81a9d7346bf0e7b5f29ad0764a6f159b68a"
  end

  resource "snowballstemmer" do
    url "https://pypi.python.org/packages/source/s/snowballstemmer/snowballstemmer-1.2.0.tar.gz"
    sha256 "6d54f350e7a0e48903a4e3b6b2cabd1b43e23765fbc975065402893692954191"
  end

  resource "six" do
    url "https://pypi.python.org/packages/source/s/six/six-1.9.0.tar.gz"
    sha256 "e24052411fc4fbd1f672635537c3fc2330d9481b18c0317695b46259512c91d5"
  end

  resource "pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
    sha256 "7320919084e6dac8f4540638a46447a3bd730fca172afc17d2c03eed22cf4f51"
  end

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz"
    sha256 "c7db717810ab6965f66c8cf0398a98c9d8df982da39b4cd7f162911eb89596fa"
  end

  resource "pytz" do
    url "https://pypi.python.org/packages/source/p/pytz/pytz-2015.4.tar.bz2"
    sha256 "a78b484d5472dd8c688f8b3eee18646a25c66ce45b2c26652850f6af9ce52b17"
  end

  resource "babel" do
    url "https://pypi.python.org/packages/source/B/Babel/Babel-2.0.tar.gz"
    sha256 "44988df191123065af9857eca68e9151526a931c12659ca29904e4f11de7ec1b"
  end

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha256 "a4ec1aff59b95a14b45eb2e23761a0179e98319da5a7eb76b56ea8cdc7b871c3"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.8.tar.gz"
    sha256 "bc1ff2ff88dbfacefde4ddde471d1417d3b304e8df103a7a9437d47269201bf4"
  end

  resource "alabaster" do
    url "https://pypi.python.org/packages/source/a/alabaster/alabaster-0.7.6.tar.gz"
    sha256 "309d33e0282c8209f792f3527f41ec04e508ff837c61fc1906dde988a256deeb"
  end

  resource "sphinx" do
    url "https://pypi.python.org/packages/source/S/Sphinx/Sphinx-1.3.1.tar.gz"
    sha256 "1a6e5130c2b42d2de301693c299f78cc4bd3501e78b610c08e45efc70e2b5114"
  end

  def install
    if build.with? "docs"
      ENV.prepend_create_path "PYTHONPATH", buildpath/"sphinx/lib/python2.7/site-packages"
      resources.each do |r|
        r.stage do
          system "python", *Language::Python.setup_install_args(buildpath/"sphinx")
        end
      end

      # There is an existing issue around OS X & Python locale setting
      # See http://bugs.python.org/issue18378#msg215215 for explanation
      ENV["LC_ALL"] = "en_US.UTF-8"
    end

    args = %W[
      --prefix=#{prefix}
      --no-system-libs
      --parallel=#{ENV.make_jobs}
      --datadir=/share/cmake
      --docdir=/share/doc/cmake
      --mandir=/share/man
      --system-curl
      --system-zlib
      --system-bzip2
    ]

    if build.with? "docs"
      args << "--sphinx-man" << "--sphinx-build=#{buildpath}/sphinx/bin/sphinx-build"
    end

    system "./bootstrap", *args
    system "make"
    system "make", "install"

    if build.with? "completion"
      cd "Auxiliary/bash-completion/" do
        bash_completion.install "ctest", "cmake", "cpack"
      end
    end

    (share/"emacs/site-lisp/cmake").install "Auxiliary/cmake-mode.el"
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system "#{bin}/cmake", "."
  end
end
