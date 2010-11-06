require 'formula'

class Kdepimlibs <Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.5.2/src/kdepimlibs-4.5.2.tar.bz2'
  homepage 'http://www.kde.org/'
  md5 '01a85ceba5f9761eeba9548b05b8f0a2'

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
