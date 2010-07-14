require 'formula'

class KdebaseRuntime <Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.4.2/src/kdebase-runtime-4.4.2.tar.bz2'
  homepage ''
  md5 'd46fca58103624c28fcdf3fbd63262eb'

  depends_on 'cmake'
  depends_on 'kde-phonon'
  depends_on 'oxygen-icons'

  def install
    phonon = Formula.factory 'kde-phonon'
    system "cmake . #{std_cmake_parameters} -DPHONON_INCLUDE_DIR=#{phonon.include} -DPHONON_LIBRARY=#{phonon.lib}/libphonon.dylib -DBUNDLE_INSTALL_DIR=#{bin}"
    system "make install"
  end
end
