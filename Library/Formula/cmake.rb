class Cmake < Formula
  desc "Cross-platform make"
  homepage "http://www.cmake.org/"
  head "http://cmake.org/cmake.git"

  stable do
    url "http://www.cmake.org/files/v3.2/cmake-3.2.3.tar.gz"
    sha256 "a1ebcaf6d288eb4c966714ea457e3b9677cdfde78820d0f088712d7320850297"

    patch do
      # Fix for older bash-completion versions.  This can be removed when 3.3.0
      # is released.
      # Use Github because upstream git changes sha and breaks from-source download.
      url "https://github.com/Kitware/CMake/commit/2ecf168f1909.diff"
      sha256 "d3f8cd71d0b6ce23a22c55145114012da916f2e42af71cbbad35090d0aeb4f68"
    end
  end

  bottle do
    cellar :any
    sha256 "52d5da6e275c0c7780d21964a8f7e7350a1978f3370b48fe4776bea0c8ab05af" => :yosemite
    sha256 "d580f7a24217854258bc73c41519579abefe8432176cef3ba4ebf5e71ad48701" => :mavericks
    sha256 "127d5cf21c33d2dc3f7b74d54dd40d3e048ddacbd28370027fb2221ac2d2bdba" => :mountain_lion
  end

  devel do
    url "http://www.cmake.org/files/v3.3/cmake-3.3.0-rc4.tar.gz"
    sha256 "986238569889ae90fd874b9fd20cff3c292d5e2b7c324273de3b1271e6934c86"
  end

  option "without-docs", "Don't build man pages"

  depends_on :python => :build if MacOS.version <= :snow_leopard && build.with?("docs")

  # The `with-qt` GUI option was removed due to circular dependencies if
  # CMake is built with Qt support and Qt is built with MySQL support as MySQL uses CMake.
  # For the GUI application please instead use brew install caskroom/cask/cmake.

  resource "sphinx" do
    url "https://pypi.python.org/packages/source/S/Sphinx/Sphinx-1.2.3.tar.gz"
    sha256 "94933b64e2fe0807da0612c574a021c0dac28c7bd3c4a23723ae5a39ea8f3d04"
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
