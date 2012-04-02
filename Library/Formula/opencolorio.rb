require 'formula'

class Opencolorio < Formula
  homepage 'http://opencolorio.org/'
  url 'https://github.com/imageworks/OpenColorIO/tarball/v1.0.6'
  sha1 '1d7a195b684fbd0687a661aa532c5cc447215420'

  head 'https://github.com/imageworks/OpenColorIO.git'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'little-cms2'

  def options
    [
      ['--with-tests', 'Verify the build with its unit tests (~1min)'],
      ['--with-python', 'Build ocio with python2.7 bindings'],
      ['--with-java', 'Build ocio with java bindings'],
      ['--with-docs', 'Build the documentation.']
    ]
  end

  def patches
    # install Python library into site-packages
    # can be removed in the next version
    [
      "https://github.com/imageworks/OpenColorIO/commit/480c5313f3b377755506e2a2b2b13e6e7988ff86.patch",
      "https://github.com/imageworks/OpenColorIO/commit/cfd4adecb630a08dba7cf7d08d5fd874bc8af120.patch",
      "https://github.com/imageworks/OpenColorIO/commit/a7fbf812291c705e7af39dfac7882c109c589387.patch"
    ]
  end

  def install
    args = std_cmake_parameters.split
    args << "-DOCIO_BUILD_JNIGLUE=ON" if ARGV.include? '--with-java'
    args << "-DOCIO_BUILD_TESTS=ON" if ARGV.include? '--with-tests'
    args << "-DOCIO_BUILD_DOCS=ON" if ARGV.include? '--with-docs'
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

    args << "-DCMAKE_OSX_SYSROOT=/" if ENV.compiler == :llvm and MacOS.lion?



    # Python note:
    # OCIO's PyOpenColorIO.so doubles as a shared library. So it lives in lib, rather
    # than the usual HOMEBREW_PREFIX/lib/python2.7/site-packages per developer choice.

    if ARGV.include? '--with-python'
      python_prefix = `python-config --prefix`.strip
      if File.exist? "#{python_prefix}/Python"
        # Python was compiled with --framework:
        args << "-DPYTHON_LIBRARY='#{python_prefix}/Python'"
        args << "-DPYTHON_INCLUDE_DIR='#{python_prefix}/Headers'"
      else
        python_version = `python-config --libs`.match('-lpython(\d+\.\d+)').captures.at(0)
        python_lib = "#{python_prefix}/lib/libpython#{python_version}"
        args << "-DPYTHON_INCLUDE_DIR='#{python_prefix}/include/python#{python_version}'"
        if File.exists? "#{python_lib}.a"
          args << "-DPYTHON_LIBRARY='#{python_lib}.a'"
        else
          args << "-DPYTHON_LIBRARY='#{python_lib}.dylib'"
        end
      end
    else
      args << "-DOCIO_BUILD_PYGLUE=OFF"
    end

    args << '..'

    mkdir 'macbuild' do
      system "cmake", *args
      system "make"
      system "make test" if ARGV.include? '--with-tests'
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
