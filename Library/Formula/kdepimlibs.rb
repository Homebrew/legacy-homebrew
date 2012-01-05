require 'formula'

class Kdepimlibs < Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.7.4/src/kdepimlibs-4.7.4.tar.bz2'
  homepage 'http://www.kde.org/'
  md5 'ccc9d9ec4173e5627623d93207fdf318'

  depends_on 'cmake' => :build
  depends_on 'automoc4' => :build
  depends_on 'gpgme'
  depends_on 'akonadi'
  depends_on 'libical'
  depends_on 'kdelibs'
  depends_on 'nepomuk' # part of kdelibs ?

  def install
    ENV.x11
    mkdir 'build'
    cd 'build'
    kdelibs = Formula.factory 'kdelibs'
    system "cmake .. -DCMAKE_INSTALL_PREFIX=#{kdelibs.prefix} -DBUILD_doc=FALSE -DBUNDLE_INSTALL_DIR=#{bin}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Remember to run brew linkapps.
    EOS
  end
end
