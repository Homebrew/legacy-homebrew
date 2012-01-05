require 'formula'

class Digikam < Formula
  url 'http://downloads.sourceforge.net/project/digikam/digikam/2.3.0/digikam-2.3.0.tar.bz2?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fdigikam%2Ffiles%2F&ts=1325610399&use_mirror=superb-sea2'
  version '2.3.0'
  homepage 'http://www.digikam.org/'
  md5 '45e635c0079a608c2d5508be8127d388'

  depends_on 'cmake' => :build
  depends_on 'automoc4' => :build
  depends_on 'kdelibs'
  depends_on 'kde-runtime'
  depends_on 'opencv'
  depends_on 'marble'

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
