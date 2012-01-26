require 'formula'

class KdebaseRuntime < Formula
  url 'http://ftp.kde.org/stable/4.8.0/src/kde-runtime-4.8.0.tar.bz2'
  homepage 'http://www.kde.org/'
  md5 '571563f6ab330348d3f917abdf9c69e4'

  depends_on 'cmake' => :build
  depends_on 'kde-phonon'
  depends_on 'oxygen-icons'

  def install
    phonon = Formula.factory 'kde-phonon'
    system "cmake . #{std_cmake_parameters} -DPHONON_INCLUDE_DIR=#{phonon.include} -DPHONON_LIBRARY=#{phonon.lib}/libphonon.dylib -DBUNDLE_INSTALL_DIR=#{bin}"
    system "make install"
  end
end
