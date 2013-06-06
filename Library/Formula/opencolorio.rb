require 'formula'

class Opencolorio < Formula
  homepage 'http://opencolorio.org/'
  url 'https://github.com/imageworks/OpenColorIO/archive/v1.0.8.tar.gz'
  sha1 '83b28202bdb1f692f74a80affea95d832354ec23'

  head 'https://github.com/imageworks/OpenColorIO.git'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'little-cms2'
  depends_on :python => :optional

  option 'with-tests', 'Verify the build with its unit tests (~1min)'
  option 'with-java', 'Build ocio with java bindings'
  option 'with-docs', 'Build the documentation'

  def install
    args = std_cmake_args
    args << "-DOCIO_BUILD_JNIGLUE=ON" if build.with? 'java'
    args << "-DOCIO_BUILD_TESTS=ON" if build.with? 'tests'
    args << "-DOCIO_BUILD_DOCS=ON" if build.with? 'docs'
    args << "-DCMAKE_VERBOSE_MAKEFILE=OFF"

    # CMake-2.8.7 + CLT + llvm + Lion => CMAKE_CXX_HAS_ISYSROOT "1"
    # CMake-2.8.7 + CLT + clang + Lion => CMAKE_CXX_HAS_ISYSROOT ""
    # CMake puts a malformed sysroot into CXX_FLAGS in flags.make with llvm.
    # Syntax like this gets added:
    #     -isysroot /Some/Wrong/SDKs/path
    # which causes c++ includes not found when compiling with llvm.
    #     https://github.com/imageworks/OpenColorIO/issues/224
    # The current workaround is that the SDK directory structure is mirrored
    # in the root directory, e.g.
    #   Xcode.app/Contents/Developer/Platforms/MacOSX.platform/Developer/SDKs/MacOSX10.7.sdk/usr/include
    #   /usr/include
    # So we just set the sysroot to /

    # args << "-DCMAKE_OSX_SYSROOT=/" if ENV.compiler == :llvm and MacOS.version >= :lion

    # Python note:
    # OCIO's PyOpenColorIO.so doubles as a shared library. So it lives in lib, rather
    # than the usual HOMEBREW_PREFIX/lib/python2.7/site-packages per developer choice.

    if python do
      # For Xcode-only systems, the headers of system's python are inside of Xcode:
      args << "-DPYTHON_INCLUDE_DIR='#{python.incdir}'"
      # Cmake picks up the system's python dylib, even if we have a brewed one:
      args << "-DPYTHON_LIBRARY='#{python.libdir}/lib#{python.xy}.dylib'"
    end; else
      args << "-DOCIO_BUILD_PYGLUE=OFF"
    end

    args << '..'

    mkdir 'macbuild' do
      system "cmake", *args
      system "make"
      system "make test" if build.with? 'tests'
      system "make install"
    end
  end

  def caveats
    <<-EOS.undent
      OpenColorIO requires several environment variables to be set.
      You can source the following script in your shell-startup to do that:
          #{HOMEBREW_PREFIX}/share/ocio/setup_ocio.sh
      Alternatively the documentation describes what env-variables need set:
          http://opencolorio.org/installation.html#environment-variables
      You will require a config for OCIO to be useful. Sample configuration files
      and reference images can be found at:
          http://opencolorio.org/downloads.html

    EOS
  end
end
