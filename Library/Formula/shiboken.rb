require 'formula'

class Shiboken < Formula
  homepage 'http://www.pyside.org/docs/shiboken'
  url 'http://qt-project.org/uploads/pyside/shiboken-1.1.2.tar.bz2'
  mirror 'https://distfiles.macports.org/py-shiboken/shiboken-1.1.2.tar.bz2'
  sha1 '2ffe9d47a3f536840ed9d7eff766a53040bb2a2e'

  depends_on 'cmake' => :build
  depends_on :python => :recommended
  depends_on :python3 => :optional
  depends_on 'qt'

  def install
    # Building the tests also runs them. Not building and running tests cuts
    # install time in half. As of 1.1.1 the install fails unless you do an
    # out of tree build and put the source dir last in the args.
    python do
      # This block will be run for each python (2.x and 3.x if requested)!
      mkdir "macbuild#{python.if3then3}" do
        args = std_cmake_args
        args << "-DBUILD_TESTS=OFF"
        # For Xcode-only systems, the headers of system's python are inside of Xcode:
        args << "-DPYTHON#{python.if3then3}_INCLUDE_DIR='#{python.incdir}'"
        # Cmake picks up the system's python dylib, even if we have a brewed one:
        args << "-DPYTHON#{python.if3then3}_LIBRARY='#{python.libdir}/lib#{python.xy}.dylib'"
        args << "-DUSE_PYTHON3=ON" if python3
        args << '..'
        system 'cmake', *args
        system "make install"
        # To support 2.x and 3.x in parallel, we have to rename shiboken.pc at first
        mv lib/'pkgconfig/shiboken.pc', lib/"pkgconfig/shiboken-py#{python.version.major}.pc"
      end
    end
    # Rename shiboken-py2.pc back to the default shiboken.pc
    mv lib/'pkgconfig/shiboken-py2.pc', lib/'pkgconfig/shiboken.pc' if python2
  end

  def caveats
    if python3
      <<-EOS.undent
        If you build software that uses the pkgconfig file, and you want
        shiboken with Python 3.x support: Please, instead of 'shiboken.pc', use:
          #{HOMEBREW_PREFIX}/lib/pkgconfig/shiboken-py3.pc
      EOS
    end
  end

  def test
    system 'python', "-c", "import shiboken" if Tab.for_formula('Shiboken').with? 'python'
    system 'python3', "-c", "import shiboken" if Tab.for_formula('Shiboken').with? 'python3'
  end
end
