class Pyqt5 < Formula
  desc "Python bindings for v5 of Qt"
  homepage "http://www.riverbankcomputing.co.uk/software/pyqt/download5"
  url "https://downloads.sourceforge.net/project/pyqt/PyQt5/PyQt-5.5/PyQt-gpl-5.5.tar.gz"
  sha256 "cdd1bb55b431acdb50e9210af135428a13fb32d7b1ab86e972ac7101f6acd814"

  bottle do
    sha256 "031c5f439bb11d97d2262edce4b50151bd94272cea8889dee710c6eadfd8c3db" => :yosemite
    sha256 "02276afa07267aa91f61e98a411172e59de31dbfceb253581d184c1a0fed096d" => :mavericks
    sha256 "d514535d8c758b7a978c99d38d2275adab714846dd33885e72c98d3a73a84ca5" => :mountain_lion
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
