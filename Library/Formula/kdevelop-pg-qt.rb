require 'formula'

class KdevelopPgQt < Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/kdevelop-pg-qt/0.9.5/src/kdevelop-pg-qt-0.9.5.tar.bz2'
  homepage 'http://www.kde.org/'
  md5 '4818af0deea47d583adff7c134d62e08'

  depends_on 'cmake' => :build
  depends_on 'kdevelop'

  def install
    # doesn't work with llvm or gcc, too old.
    ENV.clang
    phonon = Formula.factory('kde-phonon')
    args = std_cmake_parameters.split + [
      "-DPHONON_INCLUDE_DIR=#{phonon.include}",
      "-DPHONON_LIBRARY=#{phonon.lib}/libphonon.dylib",
      "-DBUNDLE_INSTALL_DIR=#{bin}"
    ]
    mkdir "build"
    cd "build"
    args << ".."
    system "cmake", *args
    system "make install"
  end
end
