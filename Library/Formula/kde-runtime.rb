require 'formula'

<<<<<<< HEAD:Library/Formula/kde-runtime.rb
class KdeRuntime < Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.7.4/src/kde-runtime-4.7.4.tar.bz2'
  homepage 'http://www.kde.org/'
  md5 '8e6af5f464ae06e3b7cbfd73aa9f7971'
=======
class KdebaseRuntime < Formula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.6.0/src/kdebase-runtime-4.6.0.tar.bz2'
  md5 '1f9d6bc64d7b84a74dd3ab06615c71ce'
>>>>>>> 0e8ea8aae9dadda53d0dc0cf680d383981770be9:Library/Formula/kdebase-runtime.rb

  depends_on 'cmake' => :build
  depends_on 'kde-phonon'
  depends_on 'kdelibs'
  depends_on 'oxygen-icons'
  
  def install
    phonon = Formula.factory 'kde-phonon'
    system "cmake #{std_cmake_parameters} -DPHONON_INCLUDE_DIR=#{phonon.include} -DPHONON_LIBRARY=#{phonon.lib}/libphonon.dylib -DBUNDLE_INSTALL_DIR=#{bin} ."
    system "make install"
    
  end

end
