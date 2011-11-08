require 'formula'

class KdevelopPhp < Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/kdevelop/4.2.3/src/kdevelop-php-1.2.3.tar.bz2'
  homepage 'http://kdevelop.org/'
  md5 '8c02ee377a740d01ef27379fee76d143'

  depends_on 'cmake' => :build
  depends_on 'kdevelop-pg-qt'
  depends_on 'kdevelop-php-docs'

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
