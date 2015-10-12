class Pyqt5 < Formula
  desc "Python bindings for v5 of Qt"
  homepage "http://www.riverbankcomputing.co.uk/software/pyqt/download5"
  url "https://downloads.sourceforge.net/project/pyqt/PyQt5/PyQt-5.5/PyQt-gpl-5.5.tar.gz"
  sha256 "cdd1bb55b431acdb50e9210af135428a13fb32d7b1ab86e972ac7101f6acd814"
  revision 1

  bottle do
    sha256 "ce5dbd7dbf9d8377500226050ee1205d979679340443c18612d5d66f3ffb3ee2" => :yosemite
    sha256 "d40d3b90566540600d830931ff7f493ecaac3baf9f723a444116a945d7203660" => :mavericks
    sha256 "9f07294fb874a412a62f93f90382d22a1177f29c589c2b7bf331974b7656d952" => :mountain_lion
  end

  option "enable-debug", "Build with debug symbols"
  option "with-docs", "Install HTML documentation and python examples"

  depends_on :python3 => :recommended
  depends_on :python => :optional

  if build.without?("python3") && build.without?("python")
    odie "pyqt5: --with-python3 must be specified when using --without-python"
  end

  depends_on "qt5"

  if build.with? "python3"
    depends_on "sip" => "with-python3"
  else
    depends_on "sip"
  end

  def install
    Language::Python.each_python(build) do |python, version|
      args = ["--confirm-license",
              "--bindir=#{bin}",
              "--destdir=#{lib}/python#{version}/site-packages",
              # To avoid conflicts with PyQt (for Qt4):
              "--sipdir=#{share}/sip/Qt5/",
              # sip.h could not be found automatically
              "--sip-incdir=#{Formula["sip"].opt_include}",
              # Make sure the qt5 version of qmake is found.
              # If qt4 is linked it will pickup that version otherwise.
              "--qmake=#{Formula["qt5"].bin}/qmake",
              # Force deployment target to avoid libc++ issues
              "QMAKE_MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}",
              "--qml-plugindir=#{pkgshare}/plugins",
              "--verbose"]
      args << "--debug" if build.include? "enable-debug"

      system python, "configure.py", *args
      system "make"
      system "make", "install"
      system "make", "clean"
    end
    doc.install "doc/html", "examples" if build.with? "docs"
  end

  test do
    system "pyuic5", "--version"
    system "pylupdate5", "-version"
    Language::Python.each_python(build) do |python, _version|
      system python, "-c", "import PyQt5"
    end
  end
end
