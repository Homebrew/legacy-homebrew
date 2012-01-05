require 'formula'

class Amarok < Formula
  url 'ftp://ftp.gtlib.cc.gatech.edu/pub/kde/stable/amarok/2.5.0/src/amarok-2.5.0.tar.bz2'
  homepage 'http://amarok.kde.org/'
  md5 'b7983eaa33e4771769ae9e330c811995'

  # Required
  depends_on 'cmake' => :build
  depends_on 'automoc4' => :build
  depends_on 'kdelibs'
  depends_on 'kde-runtime'
  #depends_on 'zlib'
  depends_on 'curl'
  depends_on 'libxml2'
  depends_on 'openssl'
  depends_on 'mysql' # --with-embedded --universal
  depends_on 'gettext'
  # Optional
  depends_on 'loudmouth'
  depends_on 'libmtp'
  depends_on 'gdk-pixbuf'
  depends_on 'libgpod'
  depends_on 'ffmpeg'
  depends_on 'liblastfm'
  depends_on 'QJson'
  depends_on 'qca'

  #depends_on 'libmygpo-qt' # requires GCC 4.3 ? 4.4 ?

  # needs patching...
  # http://code.google.com/p/musicip-libofa/issues/detail?id=1
  #depends_on 'libofa'

  #depends_on 'qtscript-qt'
  #depends_on 'qtscriptgenerator'
    
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
