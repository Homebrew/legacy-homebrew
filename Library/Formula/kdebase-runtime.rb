require 'formula'

class KdebaseRuntime <Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.6.0/src/kdebase-runtime-4.6.0.tar.bz2'
  homepage 'http://www.kde.org/'
  md5 '1f9d6bc64d7b84a74dd3ab06615c71ce'

  depends_on 'cmake' => :build
  depends_on 'kde-phonon'
  depends_on 'oxygen-icons'

  def install
    phonon = Formula.factory 'kde-phonon'
    system "cmake . #{std_cmake_parameters} -DPHONON_INCLUDE_DIR=#{phonon.include} -DPHONON_LIBRARY=#{phonon.lib}/libphonon.dylib -DBUNDLE_INSTALL_DIR=#{bin}"
    system "make install"
  end
end
