require 'formula'

class KdePhonon <Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/phonon/4.4.3/phonon-4.4.3.tar.bz2'
  homepage 'http://phonon.kde.org/'
  md5 '14e7c9a24da75113a69a12d6a50247a5'

  depends_on 'cmake' => :build
  depends_on 'automoc4' => :build
  depends_on 'qt'

  keg_only "This package is already supplied by Qt and is only needed by KDE packages."

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
