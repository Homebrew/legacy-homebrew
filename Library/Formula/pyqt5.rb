require 'formula'

class Pyqt5 < Formula
  homepage 'http://www.riverbankcomputing.co.uk/software/pyqt/download5'
  url 'http://downloads.sf.net/project/pyqt/PyQt5/PyQt-5.2/PyQt-gpl-5.2.tar.gz'
  sha1 'a1c232d34ab268587c127ad3097c725ee1a70cf0'

  option 'enable-debug', "Build with debug symbols"

  depends_on :python3 => :recommended
  depends_on :python => :optional

  if !Formula["python"].installed? && build.with?("python") &&
     build.with?("python3")
    odie <<-EOS.undent
      pyqt5: You cannot use system Python 2 and Homebrew's Python 3 simultaneously.
      Either `brew install python` or use `--without-python3`.
    EOS
  elsif build.without?("python3") && build.without?("python")
    odie "pyqt5: --with-python3 must be specified when using --without-python"
  end

  depends_on 'qt5'

  if build.with? 'python3'
    depends_on 'sip' => 'with-python3'
  else
    depends_on 'sip'
  end

  def pythons
    pythons = []
    ["python", "python3"].each do |python|
      next if build.without? python
      version = /\d\.\d/.match `#{python} --version 2>&1`
      pythons << [python, version]
    end
    pythons
  end

  def install
    pythons.each do |python, version|
      args = [ "--confirm-license",
               "--bindir=#{bin}",
               "--destdir=#{lib}/python#{version}/site-packages",
               # To avoid conflicts with PyQt (for Qt4):
               "--sipdir=#{share}/sip/Qt5/",
               # sip.h could not be found automatically
               "--sip-incdir=#{Formula["sip"].opt_prefix}/include",
               # Force deployment target to avoid libc++ issues
               "QMAKE_MACOSX_DEPLOYMENT_TARGET=#{MacOS.version}" ]
      args << '--debug' if build.include? 'enable-debug'

      system python, "configure.py", *args
      system "make"
      system "make", "install"
      system "make", "clean" if pythons.length > 1
    end
  end

  test do
    system "pyuic5", "--version"
    system "pylupdate5", "-version"
    pythons.each do |python, version|
      system python, "-c", "import PyQt5"
    end
  end
end
