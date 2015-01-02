class Pyqt < Formula
  homepage "http://www.riverbankcomputing.co.uk/software/pyqt"
  url "https://downloads.sf.net/project/pyqt/PyQt4/PyQt-4.11.1/PyQt-mac-gpl-4.11.1.tar.gz"
  sha1 "9d7478758957c60ac5007144a0dc7f157f4a5836"

  bottle do
    revision 2
    sha1 "6e5d9bd61aa0d9f888f7d61496322db45499b7a1" => :yosemite
    sha1 "4c1d4d5600013bd12fe630290d8b669c8f78b081" => :mavericks
    sha1 "379c1f1800a61f66b84b77b1602d8bf483fed058" => :mountain_lion
  end

  option "without-python", "Build without python 2 support"
  depends_on :python3 => :optional

  if build.without?("python3") && build.without?("python")
    odie "pyqt: --with-python3 must be specified when using --without-python"
  end

  depends_on "qt"

  if build.with? "python3"
    depends_on "sip" => "with-python3"
  else
    depends_on "sip"
  end

  def install
    # On Mavericks we want to target libc++, this requires a non default qt makespec
    if ENV.compiler == :clang and MacOS.version >= :mavericks
      ENV.append "QMAKESPEC", "unsupported/macx-clang-libc++"
    end

    Language::Python.each_python(build) do |python, version|
      ENV.append_path "PYTHONPATH", "#{Formula["sip"].opt_lib}/python#{version}/site-packages"

      args = ["--confirm-license",
              "--bindir=#{bin}",
              "--destdir=#{lib}/python#{version}/site-packages",
              "--sipdir=#{share}/sip"]

      # We need to run "configure.py" so that pyqtconfig.py is generated, which
      # is needed by QGIS, PyQWT (and many other PyQt interoperable
      # implementations such as the ROS GUI libs). This file is currently needed
      # for generating build files appropriate for the qmake spec that was used
      # to build Qt.  The alternatives provided by configure-ng.py is not
      # sufficient to replace pyqtconfig.py yet (see
      # https://github.com/qgis/QGIS/pull/1508). Using configure.py is
      # deprecated and will be removed with SIP v5, so we do the actual compile
      # using the newer configure-ng.py as recommended. In order not to
      # interfere with the build using configure-ng.py, we run configure.py in a
      # temporary directory and only retain the pyqtconfig.py from that.

      require "tmpdir"
      dir = Dir.mktmpdir
      begin
        cp_r(Dir.glob('*'), dir)
        cd dir do
          system python, "configure.py", *args
          (lib/"python#{version}/site-packages/PyQt4").install "pyqtconfig.py"
        end
      ensure
        remove_entry_secure dir
      end

      # On Mavericks we want to target libc++, this requires a non default qt makespec
      if ENV.compiler == :clang and MacOS.version >= :mavericks
        args << "--spec" << "unsupported/macx-clang-libc++"
      end

      system python, "configure-ng.py", *args
      system "make"
      system "make", "install"
      system "make", "clean"  # for when building against multiple Pythons
    end
  end

  def caveats
    "Phonon support is broken."
  end

  test do
    Pathname("test.py").write <<-EOS.undent
      from PyQt4 import QtNetwork
      QtNetwork.QNetworkAccessManager().networkAccessible()
    EOS

    Language::Python.each_python(build) do |python, version|
      system python, "test.py"
    end
  end
end
