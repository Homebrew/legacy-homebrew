require 'formula'

class Kdepimlibs < Formula
  url 'http://ftp.kde.org/stable/4.8.0/src/kdepimlibs-4.8.0.tar.bz2'
  homepage 'http://www.kde.org/'
  md5 '3e1ea1d5f56eb87c0c305d941ac414c0'

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
