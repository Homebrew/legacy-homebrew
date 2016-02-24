class Pyside < Formula
  desc "Python bindings for Qt"
  homepage "https://wiki.qt.io/PySide"
  url "https://download.qt.io/official_releases/pyside/pyside-qt4.8+1.2.2.tar.bz2"
  mirror "https://distfiles.macports.org/py-pyside/pyside-qt4.8+1.2.2.tar.bz2"
  sha256 "a1a9df746378efe52211f1a229f77571d1306fb72830bbf73f0d512ed9856ae1"
  revision 1

  head "https://github.com/PySide/PySide.git"

  bottle do
    sha256 "d1f7a38b75e85ebdbb73d15ecd4b2154b236c80a790f021c9f70f95bc839d926" => :el_capitan
    sha256 "8c2463514cd2133b9237143ceb2d73e64f96ff162c5c302b28f894132ad88490" => :yosemite
    sha256 "fbc427b84b145fe0fa0a2a52e246f673e763da2b1eeec8deda872571602bb7b1" => :mavericks
  end

  # don't use depends_on :python because then bottles install Homebrew's python
  option "without-python", "Build without python 2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on :python3 => :optional

  option "without-docs", "Skip building documentation"

  depends_on "cmake" => :build
  depends_on "sphinx-doc" => :build if build.with? "docs"
  depends_on "qt"

  if build.with? "python3"
    depends_on "shiboken" => "with-python3"
  else
    depends_on "shiboken"
  end

  def install
    rm buildpath/"doc/CMakeLists.txt" if build.without? "docs"

    # Add out of tree build because one of its deps, shiboken, itself needs an
    # out of tree build in shiboken.rb.
    Language::Python.each_python(build) do |python, version|
      abi = `#{python} -c 'import sysconfig as sc; print(sc.get_config_var("SOABI"))'`.strip
      python_suffix = python == "python" ? "-python2.7" : ".#{abi}"
      mkdir "macbuild#{version}" do
        qt = Formula["qt"].opt_prefix
        args = std_cmake_args + %W[
          -DSITE_PACKAGE=#{lib}/python#{version}/site-packages
          -DALTERNATIVE_QT_INCLUDE_DIR=#{qt}/include
          -DQT_SRC_DIR=#{qt}/src
          -DPYTHON_SUFFIX=#{python_suffix}
        ]
        args << ".."
        system "cmake", *args
        system "make"
        system "make", "install"
      end
    end

    inreplace include/"PySide/pyside_global.h", Formula["qt"].prefix, Formula["qt"].opt_prefix
  end

  test do
    Language::Python.each_python(build) do |python, _version|
      system python, "-c", "from PySide import QtCore"
    end
  end
end
