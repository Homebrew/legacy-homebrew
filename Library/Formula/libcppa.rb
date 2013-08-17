require 'formula'

class Libcppa < Formula
  homepage 'http://libcppa.blogspot.it'
  version '0.7.1'
  url 'https://github.com/Neverlord/libcppa.git'
  sha1 '7a8f36499ffacf2f471252280977eb5d877af759'

  option 'dual-build', 'Build both with gcc and clang'
  option 'no-examples', 'Build libcppa without examples'
  option 'no-qt-examples', 'Build libcppa with all but Qt examples'
  option 'build-static', 'Build libcppa as static and shared library'
  option 'build-static-only', 'Build libcppa as static library only'
  option 'with-opencl', 'Build with OpenCL actors'
  option 'disable-context-switching', 'Compile libcppa without context-switching actors even if Boost.Context is available'

  option 'enable-debug', 'Compile in debugging mode'
  option 'enable-perftools', 'Use Google perftools'

  depends_on 'cmake' => :build

  def install
    system "./configure"
    system "make", "install"
    system "make", "test"
  end
end
