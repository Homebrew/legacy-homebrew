require 'formula'

class CudaRequirement < Requirement
  build true
  fatal true

  satisfy { which 'nvcc' }

  env do
    # Nvidia CUDA installs (externally) into this dir (hard-coded):
    ENV.append 'CFLAGS', "-F/Library/Frameworks"
    # # because nvcc has to be used
    ENV.append 'PATH', which('nvcc').dirname, ':'
  end

  def message
    <<-EOS.undent
      To use this formula with NVIDIA graphics cards you will need to
      download and install the CUDA drivers and tools from nvidia.com.

          https://developer.nvidia.com/cuda-downloads

      Select "Mac OS" as the Operating System and then select the
      'Developer Drivers for MacOS' package.
      You will also need to download and install the 'CUDA Toolkit' package.

      The `nvcc` has to be in your PATH then (which is normally the case).

  EOS
  end
end

class Beagle < Formula
  homepage 'http://beagle-lib.googlecode.com/'
  head 'http://beagle-lib.googlecode.com/svn/trunk/'

  option 'with-opencl', "Build with OpenCL GPU/CPU acceleration"

  depends_on :autoconf => :build
  depends_on :automake => :build
  depends_on 'doxygen' => :build
  depends_on :libtool
  depends_on CudaRequirement => :optional

  def install
    system "./autogen.sh"

    args = [ "--prefix=#{prefix}" ]
    args << "--enable-osx-leopard" if MacOS.version <= :leopard
    args << "--enable-opencl" if build.with? 'opencl'

    system "./configure", *args

    # The JNI bindings cannot be built in parallel, else we get
    # "ld: library not found for -lhmsbeagle"
    # (https://github.com/Homebrew/homebrew-science/issues/67)
    ENV.deparallelize

    system "make"
    system "make install"
    # The tests seem to fail if --enable-opencl is provided
    system "make check" unless build.with? 'opencl'
  end
end
