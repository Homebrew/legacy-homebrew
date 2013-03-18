require 'formula'

def which_python
  "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
end

def site_package_dir
  "lib/#{which_python}/site-packages"
end

class Opencv < Formula
  homepage 'http://opencv.org/'
  url 'http://sourceforge.net/projects/opencvlibrary/files/opencv-unix/2.4.4/OpenCV-2.4.4a.tar.bz2'
  sha1 '6e518c0274a8392c0c98d18ef0ef754b9c596aca'

  env :std # to find python

  option '32-bit'
  option 'with-qt',  'Build the Qt4 backend to HighGUI'
  option 'with-tbb', 'Enable parallel code in OpenCV using Intel TBB'
  option 'with-opencl', 'Enable gpu code in OpenCV using OpenCL'

  # CLT-only couldn't install this out-of-the-box.
  # From the build error:
  # set CMAKE_OSX_SYSROOT to a valid SDK or
  # set CMAKE_OSX_DEPLOYMENT_TARGET to empty
  depends_on :xcode

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'numpy' => :python

  depends_on 'eigen'   => :optional
  depends_on 'libtiff' => :optional
  depends_on 'jasper'  => :optional
  depends_on 'tbb'     => :optional
  depends_on 'qt'      => :optional
  depends_on :libpng

  # Can also depend on ffmpeg, but this pulls in a lot of extra stuff that
  # you don't need unless you're doing video analysis, and some of it isn't
  # in Homebrew anyway. Will depend on openexr if it's installed.

  def install
    args = std_cmake_args + %w[
      -DWITH_CUDA=OFF
      -DBUILD_ZLIB=OFF
      -DBUILD_TIFF=OFF
      -DBUILD_PNG=OFF
      -DBUILD_JPEG=OFF
      -DBUILD_JASPER=OFF
      -DBUILD_TESTS=OFF
      -DBUILD_PERF_TESTS=OFF
    ]
    if build.build_32_bit?
      args << "-DCMAKE_OSX_ARCHITECTURES=i386"
      args << "-DOPENCV_EXTRA_C_FLAGS='-arch i386 -m32'"
      args << "-DOPENCV_EXTRA_CXX_FLAGS='-arch i386 -m32'"
    end
    args << '-DWITH_QT=ON' if build.with? 'qt'
    args << '-DWITH_TBB=ON' if build.with? 'tbb'
    args << '-DWITH_OPENCL=ON' if build.with? 'opencl'

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
    args << "-DPYTHON_PACKAGES_PATH='#{lib}/#{which_python}/site-packages'"

    args << '..'
    mkdir 'macbuild' do
      system 'cmake', *args
      system "make"
      system "make install"
    end
  end

  def caveats; <<-EOS.undent
    The OpenCV Python module will not work until you edit your PYTHONPATH like so:
      export PYTHONPATH="#{HOMEBREW_PREFIX}/#{site_package_dir}:$PYTHONPATH"

    To make this permanent, put it in your shell's profile (e.g. ~/.profile).
    EOS
  end
end
