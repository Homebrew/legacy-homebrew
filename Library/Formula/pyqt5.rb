require 'formula'

class Pyqt5 < Formula
  desc "Python bindings for v5 of Qt"
  homepage "http://www.riverbankcomputing.co.uk/software/pyqt/download5"
  url "https://downloads.sf.net/project/pyqt/PyQt5/PyQt-5.4.2/PyQt-gpl-5.4.2.tar.gz"
  sha256 "4cd90580558722ef24d499700faafbdc242d930cb36f55cc1a27b5cf67b10290"

  bottle do
    sha256 "bb04bac3c3495dbaac4fb3f0a2ccf082e6f26b3576167d256e2eac6ec34d709c" => :yosemite
    sha256 "9f8a400a1958632ee2a81c467e2b02e15dae02159243f1096f1f37ed46f3216b" => :mavericks
    sha256 "c1c2046fccea79524266cf396719a4103ce749de2167dde3f174ec3f18a3bdea" => :mountain_lion
  end

  option 'enable-debug', "Build with debug symbols"
  option 'with-docs', "Install HTML documentation and python examples"

  depends_on :python3 => :recommended
  depends_on :python => :optional

  if build.without?("python3") && build.without?("python")
    odie "pyqt5: --with-python3 must be specified when using --without-python"
  end

  depends_on 'qt5'

  if build.with? 'python3'
    depends_on 'sip' => 'with-python3'
  else
    depends_on 'sip'
  end

  def install
    Language::Python.each_python(build) do |python, version|
      args = [ "--confirm-license",
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
      args << '--debug' if build.include? 'enable-debug'

      system python, "configure.py", *args
      system "make"
      system "make", "install"
      system "make", "clean"
    end
    doc.install 'doc/html', 'examples' if build.with? "docs"
  end

  test do
    system "pyuic5", "--version"
    system "pylupdate5", "-version"
    Language::Python.each_python(build) do |python, version|
      system python, "-c", "import PyQt5"
    end
  end
end
