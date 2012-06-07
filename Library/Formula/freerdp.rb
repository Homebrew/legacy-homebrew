require 'formula'

class Freerdp < Formula
  homepage 'http://www.freerdp.com/'
  url 'https://github.com/FreeRDP/FreeRDP/tarball/1.0.1'
  md5 '1282189a87893bf196da20382e45f6c1'

  head 'https://github.com/FreeRDP/FreeRDP.git'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build

  # Fixes clang build problems
  # Already upstream, check for removal on 1.1 release:
  # https://github.com/FreeRDP/FreeRDP/pull/544
  def patches
    'https://github.com/bmiklautz/FreeRDP/commit/1d32894775edd1bacdbcb4b6c3e129841b637374.patch'
  end

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
