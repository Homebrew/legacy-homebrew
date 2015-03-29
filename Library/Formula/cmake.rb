class Cmake < Formula
  homepage "http://www.cmake.org/"
  url "http://www.cmake.org/files/v3.2/cmake-3.2.1.tar.gz"
  sha1 "53c1fe2aaae3b2042c0fe5de177f73ef6f7b267f"
  head "http://cmake.org/cmake.git"

  bottle do
    cellar :any
    revision 2
    sha256 "99411c03795b8ef85e52b5296d54540af18724215f67a66686737e91abec35a8" => :yosemite
    sha256 "ce230e1dff6108a48083ab36dfc5ae8011b03244c950557b8acfcf3189a4f146" => :mavericks
    sha256 "e8b6dd510da6ce5523dba550ac36d9d82b86952f9ed3d924e5d10e892f0fc94c" => :mountain_lion
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
  end

  test do
    (testpath/"CMakeLists.txt").write("find_package(Ruby)")
    system "#{bin}/cmake", "."
  end
end
