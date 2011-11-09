require 'formula'

class KdeRuntime < Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.7.3/src/kde-runtime-4.7.3.tar.bz2'
  homepage 'http://www.kde.org/'
  md5 '1b80879c37e7ab1d23e224d687e8e630'

  depends_on 'cmake' => :build
  depends_on 'kde-phonon'
  depends_on 'oxygen-icons'

  def install
    phonon = Formula.factory('kde-phonon')
    args = std_cmake_parameters.split + [
      "-DPHONON_INCLUDE_DIR=#{phonon.include}",
      "-DPHONON_LIBRARY=#{phonon.lib}/libphonon.dylib",
      "-DBUNDLE_INSTALL_DIR=#{bin}",
      "-DWITH_QZeitgeist=OFF",
      "-DWITH_QNtrack=OFF",
      "-DWITH_Samba=OFF",
      "-DKDEBASE_DISABLE_MULTIMEDIA=ON"
    ]
    args << "."
    system "cmake", *args
    system "make install"
  end
end
