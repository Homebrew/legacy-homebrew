require 'formula'

class Kdepimlibs < Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.6.0/src/kdepimlibs-4.6.0.tar.bz2'
  homepage 'http://www.kde.org/'
  md5 'bfcc74fff5c6d0803d43cf13033660ab'

  depends_on 'cmake' => :build
  depends_on 'gpgme'
  depends_on 'akonadi'
  depends_on 'libical'
  depends_on 'kdelibs'

  def install
    system "cmake . #{std_cmake_parameters} -DBUNDLE_INSTALL_DIR=#{bin}"
    system "make install"
  end
end
