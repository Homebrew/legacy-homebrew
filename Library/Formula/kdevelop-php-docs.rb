require 'formula'

class KdevelopPhpDocs < Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/kdevelop/4.2.3/src/kdevelop-php-docs-1.2.3.tar.bz2'
  homepage 'http://kdevelop.org/'
  md5 '4f743665b610b75f5abb892378e69799'

  depends_on 'cmake' => :build

  def install
    gettext_prefix = Formula.factory('gettext').prefix
    phonon = Formula.factory('kde-phonon')
    args = std_cmake_parameters.split + [
      "-DCMAKE_PREFIX_PATH=#{gettext_prefix}",
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
