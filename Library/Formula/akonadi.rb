require 'formula'

class Akonadi < Formula
  url 'ftp://ftp.gtlib.cc.gatech.edu/pub/kde/stable/akonadi/src/akonadi-1.6.2.tar.bz2'
  homepage 'http://pim.kde.org/akonadi/'
  md5 '07e2aa2e6953ac518f9306911747e264'

  depends_on 'cmake' => :build
  depends_on 'automoc4' => :build
  depends_on 'shared-mime-info'
  depends_on 'mysql'
  depends_on 'soprano'
  depends_on 'boost'
  depends_on 'qt'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
