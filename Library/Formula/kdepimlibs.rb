require 'formula'

class Kdepimlibs <Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.4.1/src/kdepimlibs-4.4.1.tar.bz2'
  homepage 'http://www.kde.org/'
  md5 'dab906c8ea41551b8d494ff9a696d20a'

  depends_on 'cmake'
  depends_on 'gpgme'
  depends_on 'akonadi'
  depends_on 'libical'
  depends_on 'kdelibs'

  def install
    system "cmake . #{std_cmake_parameters} -DBUNDLE_INSTALL_DIR=#{bin}"
    system "make install"
  end
end
