class Cmake < Formula
  desc "Cross-platform make"
  homepage "http://www.cmake.org/"
  url "http://www.cmake.org/files/v3.2/cmake-3.2.2.tar.gz"
  sha256 "ade94e6e36038774565f2aed8866415443444fb7a362eb0ea5096e40d5407c78"
  head "http://cmake.org/cmake.git"

  bottle do
    cellar :any
    revision 3
    sha256 "da3c5fae000164e94cf2a58ca9ec7cc970b009f9413443af903e5069eb564dc3" => :yosemite
    sha256 "147aa92c60d006b544aaef8a4fe549d3ce35de6265d9476d66853939fa33e4ca" => :mavericks
    sha256 "d9ccd1a85b5376a4b0dce0563f7c705ad21df0f379b31fe98fffdcda2c4fe21a" => :mountain_lion
  end

  option "without-docs", "Don't build man pages"

  depends_on :python => :build if MacOS.version <= :snow_leopard && build.with?("docs")

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use brew install caskroom/cask/cmake.

  resource "sphinx" do
    url "https://pypi.python.org/packages/source/S/Sphinx/Sphinx-1.2.3.tar.gz"
    sha1 "3a11f130c63b057532ca37fe49c8967d0cbae1d5"
  end

  resource "docutils" do
    url "https://pypi.python.org/packages/source/d/docutils/docutils-0.12.tar.gz"
    sha1 "002450621b33c5690060345b0aac25bc2426d675"
  end

  resource "pygments" do
    url "https://pypi.python.org/packages/source/P/Pygments/Pygments-2.0.2.tar.gz"
    sha1 "fe2c8178a039b6820a7a86b2132a2626df99c7f8"
  end

  resource "jinja2" do
    url "https://pypi.python.org/packages/source/J/Jinja2/Jinja2-2.7.3.tar.gz"
    sha1 "25ab3881f0c1adfcf79053b58de829c5ae65d3ac"
  end

  resource "markupsafe" do
    url "https://pypi.python.org/packages/source/M/MarkupSafe/MarkupSafe-0.23.tar.gz"
    sha1 "cd5c22acf6dd69046d6cb6a3920d84ea66bdf62a"
  end

  patch do
    # fix for older bash-completion versions
    url "http://www.cmake.org/gitweb?p=cmake.git;a=commitdiff_plain;h=2ecf168f"
    sha256 "147854010874cd68289e3ca203399d5c149287167bca0b67f9c5677f0ee22eb8"
  end

  def install
    if build.with? "docs"
      ENV.prepend_create_path "PYTHONPATH", buildpath+"sphinx/lib/python2.7/site-packages"
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

    cd "Auxiliary/bash-completion/" do
      bash_completion.install "ctest", "cmake", "cpack"
    end
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system "#{bin}/cmake", "."
  end
end
