require 'formula'

class KdePhonon < Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/phonon/4.4.4/src/phonon-4.4.4.tar.bz2'
  homepage 'http://phonon.kde.org/'
  md5 '1deb14ecb2185e1f2fe2741a0bd46852'

  depends_on 'cmake' => :build
  depends_on 'automoc4' => :build
  depends_on 'qt'
  depends_on 'glib' => :build

  keg_only "This package is already supplied by Qt and is only needed by KDE packages."

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
