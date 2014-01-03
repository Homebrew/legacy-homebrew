require 'formula'

class Zmap < Formula
  homepage 'https://zmap.io'
  url "https://github.com/zmap/zmap/archive/v1.1.1.1.tar.gz"
  sha1 '0c53e6e6cfe35aefd7b018e41b80674fa25c3d49'

  head 'https://github.com/zmap/zmap.git'

  depends_on 'cmake' => :build
  depends_on 'gmp'
  depends_on 'gengetopt'
  depends_on 'byacc'
  depends_on 'libdnet'
  depends_on 'json-c' => :optional
  depends_on 'hiredis' => :optional

  def install
    args = std_cmake_args + ["-DRESPECT_INSTALL_PREFIX_CONFIG=ON", "-DENABLE_HARDENING=ON"]
    args << "-DWITH_REDIS=ON" if build.with? "hiredis"
    args << "-DWITH_JSON=ON" if build.with? "json-c"

    system "cmake", ".", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/program", "--version"
  end
end
