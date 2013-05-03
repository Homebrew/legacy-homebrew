require 'formula'

class Libplist < Formula
  homepage 'http://cgit.sukimashita.com/libplist.git/'
  url 'http://cgit.sukimashita.com/libplist.git/snapshot/libplist-1.10.tar.bz2'
  sha1 'a642bb37eaa4bec428d0b2a4fa8399d80ee73a18'

  head 'http://git.sukimashita.com/libplist.git'

  option 'with-python', 'Enable Cython Python bindings'

  depends_on 'cmake' => :build

  if build.include? 'with-python'
    depends_on 'Cython' => :python
    # Needed to find the Cython executable
    env :userpaths
  end

  def install
    ENV.deparallelize # make fails on an 8-core Mac Pro

    args = std_cmake_args

    # Disable Swig Python bindings
    args << "-DENABLE_SWIG='OFF'"

    if build.include? 'with-python'
      ## Taken from opencv.rb
      #
      # The CMake `FindPythonLibs` Module is dumber than a bag of hammers when
      # more than one python installation is available---for example, it clings
      # to the Header folder of the system Python Framework like a drowning
      # sailor.
      #
      # This code was cribbed from the VTK formula and uses the output to
      # `python-config` to do the job FindPythonLibs should be doing in the first
      # place.
      python_prefix = `python-config --prefix`.strip
      # Python is actually a library. The libpythonX.Y.dylib points to this lib, too.
      if File.exist? "#{python_prefix}/Python"
      # Python was compiled with --framework:
        args << "-DPYTHON_LIBRARY='#{python_prefix}/Python'"
        if !MacOS::CLT.installed? and python_prefix.start_with? '/System/Library'
          # For Xcode-only systems, the headers of system's python are inside of Xcode
          args << "-DPYTHON_INCLUDE_DIR='#{MacOS.sdk_path}/System/Library/Frameworks/Python.framework/Versions/2.7/Headers'"
        else
          args << "-DPYTHON_INCLUDE_DIR='#{python_prefix}/Headers'"
        end
      else
        python_lib = "#{python_prefix}/lib/lib#{which_python}"
        if File.exists? "#{python_lib}.a"
          args << "-DPYTHON_LIBRARY='#{python_lib}.a'"
        else
          args << "-DPYTHON_LIBRARY='#{python_lib}.dylib'"
        end
        args << "-DPYTHON_INCLUDE_DIR='#{python_prefix}/include/#{which_python}'"
      end
    else
      # Also disable Cython Python bindings if we're not building with '--python'
      args << "-DENABLE_CYTHON='OFF'"
    end

    system "cmake", ".", "-DCMAKE_INSTALL_NAME_DIR=#{lib}", *args
    system "make install"
  end

  def caveats
    if build.include? 'with-python'
      <<-EOS.undent
        To use the Python bindings with non-homebrew Python, you need to amend your
        PYTHONPATH like so:
          export PYTHONPATH=#{HOMEBREW_PREFIX}/lib/#{which_python}/site-packages:$PYTHONPATH
      EOS
    end
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end
