require 'formula'

def which_python
  "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
end

def site_package_dir
  "lib/#{which_python}/site-packages"
end

class Pyside < Formula
  homepage 'http://www.pyside.org'
  url 'http://www.pyside.org/files/pyside-latest.tar.bz2'
  md5 '0176d3746074afe47373d7302e1b4501'

  depends_on 'cmake' => :build
  depends_on 'shiboken'

  def install
    # The build will be unable to find Qt headers buried inside frameworks
    # unless the folder containing those frameworks is added to the compiler
    # search path.
    qt = Formula.factory 'qt'
    ENV.append_to_cflags "-F#{qt.prefix}/Frameworks"

    mkdir 'build'
    chdir 'build' do
      # Also need `ALTERNATIVE_QT_INCLUDE_DIR` to prevent "missing file" errors.
      system "cmake .. #{std_cmake_parameters} -DALTERNATIVE_QT_INCLUDE_DIR=#{qt.prefix}/Frameworks -DSITE_PACKAGE=#{site_package_dir} -DBUILD_TESTS=NO"
      system 'make install'
    end
  end

  def caveats
    <<-EOS
PySide Python modules have been linked to:
    #{HOMEBREW_PREFIX}/#{site_package_dir}

Make sure this folder is on your PYTHONPATH. For PySide development tools,
install the `pyside-tools` formula.
    EOS
  end
end
