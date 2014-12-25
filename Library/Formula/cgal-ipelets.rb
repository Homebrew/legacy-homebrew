require 'formula'

class CgalIpelets < Formula
  homepage "http://www.cgal.org/"
  url "https://gforge.inria.fr/frs/download.php/34149/CGAL-4.5.tar.gz"
  sha1 "d505d4257f214b200949d67570ad743d3a913633"

  depends_on 'cmake' => :build

  depends_on "cgal"
  depends_on "ipe"

  def install
    args = ["-DCMAKE_INSTALL_PREFIX=#{prefix}",
            "-DCMAKE_BUILD_TYPE=Release",
            "-DCMAKE_BUILD_WITH_INSTALL_RPATH=ON",
            "-DCMAKE_INSTALL_NAME_DIR=#{HOMEBREW_PREFIX}/lib"]
    args << '.'
    system "cmake", *args
    cd "demo/CGAL_ipelets"
    system "cmake . -DWITH_IPE_7=ON"
    system "make"

    (lib/"ipe/7.1.5/ipelets").mkpath
    (lib/"ipe/7.1.5/ipelets").install Dir["*.so"]
    (lib/"ipe/7.1.5/ipelets").install Dir["lua/*"]
  end
end
