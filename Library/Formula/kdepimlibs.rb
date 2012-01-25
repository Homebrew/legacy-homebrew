require 'formula'

class Kdepimlibs < Formula
  url 'http://ftp.kde.org/stable/4.7.4/src/kdepimlibs-4.7.4.tar.bz2'
  homepage 'http://www.kde.org/'
  md5 'ccc9d9ec4173e5627623d93207fdf318'

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
