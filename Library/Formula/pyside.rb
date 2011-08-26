require 'formula'

def python_vers
  "python" + `python -c 'import sys;print(sys.version[:3])'`.chomp.strip
end

class Pyside < Formula
  homepage 'http://www.pyside.org'
  url 'http://www.pyside.org/files/pyside-qt4.7+1.0.5.tar.bz2'
  md5 'b24a9dc2e111718043eecf614375f2a5'

  depends_on 'cmake' => :build

  depends_on 'shiboken'
  depends_on 'generatorrunner'
  depends_on 'apiextractor'
  depends_on 'qt'

  def install
    # The build will be unable to find Qt headers buried inside frameworks
    # unless the folder containing those frameworks is added to the compiler
    # search path.
    qt = Formula.factory 'qt'
    ENV.append_to_cflags "-F#{qt.prefix}/Frameworks"

    # Also need `ALTERNATIVE_QT_INCLUDE_DIR` to prevent "missing file" errors.
    system "cmake . #{std_cmake_parameters} -DBUILD_TESTS=NO -DALTERNATIVE_QT_INCLUDE_DIR=#{qt.prefix}/Frameworks"
    system 'make install'
  end

  def caveats
    <<-EOS
PySide Python modules have been linked to:
    #{HOMEBREW_PREFIX}/lib/#{python_vers}/site-packages

Make sure this folder is on your PYTHONPATH. For PySide development tools,
install the `pyside-tools` formula.
    EOS
  end
end
