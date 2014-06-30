require 'formula'

class Pyside < Formula
  homepage 'http://www.pyside.org'
  url 'https://download.qt-project.org/official_releases/pyside/pyside-qt4.8+1.2.2.tar.bz2'
  mirror 'https://distfiles.macports.org/py-pyside/pyside-qt4.8+1.2.2.tar.bz2'
  sha1 '955e32d193d173faa64edc51111289cdcbe3b96e'

  head 'git://gitorious.org/pyside/pyside.git'

  depends_on :python => :recommended
  depends_on :python3 => :optional

  option "without-docs", "Skip building documentation"

  depends_on 'cmake' => :build
  depends_on 'qt'

  if build.with? 'python3'
    depends_on 'shiboken' => 'with-python3'
  else
    depends_on 'shiboken'
  end

  resource 'sphinx' do
    url 'https://pypi.python.org/packages/source/S/Sphinx/Sphinx-1.2.2.tar.gz'
    sha1 '9e424b03fe1f68e0326f3905738adcf27782f677'
  end

  def install
    if build.with? "docs"
      (buildpath/"sphinx").mkpath

      resource("sphinx").stage do
        system "python", "setup.py", "install",
                                     "--prefix=#{buildpath}/sphinx",
                                     "--record=installed.txt",
                                     "--single-version-externally-managed"
      end

      ENV.prepend_path "PATH", (buildpath/"sphinx/bin")
    else
      rm buildpath/"doc/CMakeLists.txt"
    end

    # Add out of tree build because one of its deps, shiboken, itself needs an
    # out of tree build in shiboken.rb.
    Language::Python.each_python(build) do |python, version|
      mkdir "macbuild#{version}" do
        qt = Formula["qt"].opt_prefix
        args = std_cmake_args + %W[
          -DSITE_PACKAGE=#{lib}/python#{version}/site-packages
          -DALTERNATIVE_QT_INCLUDE_DIR=#{qt}/include
          -DQT_SRC_DIR=#{qt}/src
        ]
        if version.to_s[0,1] == "2"
          args << "-DPYTHON_SUFFIX=-python#{version}"
        else
          major_version = version.to_s[0,1]
          minor_version = version.to_s[2,3]
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
    Language::Python.each_python(build) do |python, version|
      system python, "-c", "from PySide import QtCore"
    end
  end
end
