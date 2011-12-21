require 'formula'

class KdebaseRuntime < Formula
  url 'http://ftp.kde.org/stable/4.7.4/src/kde-runtime-4.7.4.tar.bz2'
  homepage 'http://www.kde.org/'
  md5 '8e6af5f464ae06e3b7cbfd73aa9f7971'

  depends_on 'cmake' => :build
  depends_on 'kde-phonon'
  depends_on 'oxygen-icons'

  def install
    phonon = Formula.factory 'kde-phonon'
    system "cmake . #{std_cmake_parameters} -DPHONON_INCLUDE_DIR=#{phonon.include} -DPHONON_LIBRARY=#{phonon.lib}/libphonon.dylib -DBUNDLE_INSTALL_DIR=#{bin}"
    system "make install"
  end
end
