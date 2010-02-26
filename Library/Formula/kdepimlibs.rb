require 'formula'

class Kdepimlibs <Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.4.0/src/kdepimlibs-4.4.0.tar.bz2'
  homepage 'http://www.kde.org/'
  md5 '2eb04e5ae39a25009f036ec333eb118a'

  depends_on 'cmake'
  depends_on 'gpgme'
  depends_on 'akonadi'
  depends_on 'libical'
  depends_on 'kdelibs'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
