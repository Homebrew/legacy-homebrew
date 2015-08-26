class Pyside < Formula
  desc "Python bindings for Qt"
  homepage "http://qt-project.org/wiki/PySide"
  url "https://download.qt.io/official_releases/pyside/pyside-qt4.8+1.2.2.tar.bz2"
  mirror "https://distfiles.macports.org/py-pyside/pyside-qt4.8+1.2.2.tar.bz2"
  sha256 "a1a9df746378efe52211f1a229f77571d1306fb72830bbf73f0d512ed9856ae1"

  head "https://gitorious.org/pyside/pyside.git"

  bottle do
    sha1 "8137d4ab768f0b621c76f3e8f51aff9594527b7a" => :yosemite
    sha1 "23cceb7a03918cb1aa1e897c9ed1b3224610c2d2" => :mavericks
    sha1 "370b1d0fc1099689977ba04eb3602c41b5def89c" => :mountain_lion
  end

  # don't use depends_on :python because then bottles install Homebrew's python
  option "without-python", "Build without python 2 support"
  depends_on :python => :recommended if MacOS.version <= :snow_leopard
  depends_on :python3 => :optional

  option "without-docs", "Skip building documentation"

  depends_on "cmake" => :build
  depends_on "qt"

  if build.with? "python3"
    depends_on "shiboken" => "with-python3"
  else
    depends_on "shiboken"
  end

  resource "sphinx" do
    url "https://pypi.python.org/packages/source/S/Sphinx/Sphinx-1.2.3.tar.gz"
    sha256 "94933b64e2fe0807da0612c574a021c0dac28c7bd3c4a23723ae5a39ea8f3d04"
  end

  def install
    if build.with? "docs"
      ENV.prepend_create_path "PYTHONPATH", buildpath+"sphinx/lib/python2.7/site-packages"
      resources.each do |r|
        r.stage do
          system "python", *Language::Python.setup_install_args(buildpath/"sphinx")
        end
      end

      ENV.prepend_path "PATH", (buildpath/"sphinx/bin")
    else
      rm buildpath/"doc/CMakeLists.txt"
    end

    # Add out of tree build because one of its deps, shiboken, itself needs an
    # out of tree build in shiboken.rb.
    Language::Python.each_python(build) do |_python, version|
      mkdir "macbuild#{version}" do
        qt = Formula["qt"].opt_prefix
        args = std_cmake_args + %W[
          -DSITE_PACKAGE=#{lib}/python#{version}/site-packages
          -DALTERNATIVE_QT_INCLUDE_DIR=#{qt}/include
          -DQT_SRC_DIR=#{qt}/src
        ]
        if version.to_s[0, 1] == "2"
          args << "-DPYTHON_SUFFIX=-python#{version}"
        else
          major_version = version.to_s[0, 1]
          minor_version = version.to_s[2, 3]
          args << "-DPYTHON_SUFFIX=.cpython-#{major_version}#{minor_version}m"
          args << "-DUSE_PYTHON3=1"
        end
        args << ".."
        system "cmake", *args
        system "make"
        system "make", "install"
      end
    end
  end

  test do
    Language::Python.each_python(build) do |python, _version|
      system python, "-c", "from PySide import QtCore"
    end
  end
end
