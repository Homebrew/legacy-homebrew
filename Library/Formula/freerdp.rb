require 'formula'

class Freerdp < Formula
  homepage 'http://www.freerdp.com/'
  url 'https://github.com/FreeRDP/FreeRDP/tarball/1.0.1'
  sha1 '93a7ffaa0e0942f3446810777154bf78053cc66c'

  head 'https://github.com/FreeRDP/FreeRDP.git'

  depends_on :x11
  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build

  # Upstream; check for removal on 1.1 release.
  def patches
    [
      'https://github.com/FreeRDP/FreeRDP/commit/1d3289.patch',
      'https://github.com/FreeRDP/FreeRDP/commit/e32f9e.patch'
    ]
  end

  def install
    system "cmake", ".", "-DWITH_X11=OFF", *std_cmake_args
    system "make install"
  end
end
