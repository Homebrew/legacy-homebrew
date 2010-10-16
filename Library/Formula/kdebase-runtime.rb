require 'formula'

class KdebaseRuntime <Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.5.2/src/kdebase-runtime-4.5.2.tar.bz2'
  homepage 'http://www.kde.org/'
  md5 '6503a445c52fc1055152d46fca56eb0a'

  depends_on 'cmake' => :build
  depends_on 'kde-phonon'
  depends_on 'oxygen-icons'

  def install
    phonon = Formula.factory 'kde-phonon'
    system "cmake . #{std_cmake_parameters} -DPHONON_INCLUDE_DIR=#{phonon.include} -DPHONON_LIBRARY=#{phonon.lib}/libphonon.dylib -DBUNDLE_INSTALL_DIR=#{bin}"
    system "make install"
  end
end
