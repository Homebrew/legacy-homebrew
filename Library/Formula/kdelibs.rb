require 'formula'

class Kdelibs <Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.4.1/src/kdelibs-4.4.1.tar.bz2'
  homepage 'http://www.kde.org/'
  md5 '5057908fb9dcf7997a87fe27a382bfc9'

  depends_on 'cmake'
  depends_on 'qt'
  depends_on 'automoc4'
  depends_on 'pcre'
  depends_on 'jpeg'
  depends_on 'giflib'
  depends_on 'strigi'
  depends_on 'soprano'
  depends_on 'shared-desktop-ontologies'
  depends_on 'gettext'

  depends_on 'libpng' unless File.exist? "/usr/X11R6/lib"

  def install
    gettext = Formula.factory 'gettext'
    FileUtils.mkdir('build')
    FileUtils.cd('build')
    system "cmake .. #{std_cmake_parameters} -DCMAKE_PREFIX_PATH=#{gettext.prefix} -DBUNDLE_INSTALL_DIR=#{bin}"
    system "make install"
  end
end
