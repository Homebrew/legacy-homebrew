require 'formula'

class Marble < Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.7.4/src/marble-4.7.4.tar.bz2'
  homepage 'http://kde.org/'
  md5 '77d6be4dd6de1a81551c525ba93a409e'

  depends_on 'cmake' => :build
  depends_on 'automoc4' => :build
  depends_on 'kdelibs'

  def install
    ENV.x11
    mkdir 'build'
    cd 'build'
    gettext_prefix = Formula.factory('gettext').prefix
    kdelibs_prefix = Formula.factory('kdelibs').prefix
    # this has to be installed along with this kdelibs. // kde4-config --prefix
    system "cmake .. -DCMAKE_INSTALL_PREFIX=#{kdelibs_prefix} -DBUILD_doc=FALSE -DBUNDLE_INSTALL_DIR=#{bin} -DCMAKE_PREFIX_PATH=#{gettext_prefix} "
    system "make install"
  end

  def caveats; <<-EOS.undent
    Remember to run brew linkapps.
    EOS
  end
end
