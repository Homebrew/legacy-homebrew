require 'formula'

class Shiboken < Formula
  homepage 'http://www.pyside.org/docs/shiboken'
  url 'http://pyside.org/files/shiboken-1.1.1.tar.bz2'
  sha1 'd24efc1e7499e9d7db4dfc85a975291e3cb3f311'

  depends_on 'cmake' => :build
  depends_on 'qt'

  def install
    # Building the tests also runs them. Not building and running tests cuts
    # install time in half.  As of 1.1.1 the install fails unless you do an
    # out of tree build and put the source dir last in the args.
    mkdir 'macbuild' do
      args = std_cmake_args + %W[
        -DBUILD_TESTS=OFF
      ]


      python_prefix = `python-config --prefix`.strip
      # Python is actually a library. The libpythonX.Y.dylib points to this lib, too.
      if File.exist? "#{python_prefix}/Python"
        # Python was compiled with --framework:
        args << "-DPYTHON_LIBRARY='#{python_prefix}/Python'"
        if !MacOS.clt_installed? and python_prefix.start_with? '/System/Library'
          # For Xcode-only systems, the headers of system's python are inside of Xcode
          args << "-DPYTHON_INCLUDE_DIR='#{MacOS.sdk_path}/System/Library/Frameworks/Python.framework/Versions/2.7/Headers'"
        else
          args << "-DPYTHON_INCLUDE_DIR='#{python_prefix}/Headers'"
        end
      else
        python_version = `python-config --libs`.match('-lpython(\d+\.\d+)').captures.at(0)
        python_lib = "#{python_prefix}/lib/libpython#{python_version}"
        if File.exists? "#{python_lib}.a"
          args << "-DPYTHON_LIBRARY='#{python_lib}.a'"
        else
          args << "-DPYTHON_LIBRARY='#{python_lib}.dylib'"
        end
        args << "-DPYTHON_INCLUDE_DIR='#{python_prefix}/include/#{which_python}'"
      end


      args << '..'
      system 'cmake', *args
      system "make install"
    end
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end
