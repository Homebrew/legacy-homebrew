require 'formula'

class Kdelibs <Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.4.0/src/kdelibs-4.4.0.tar.bz2'
  homepage 'http://www.kde.org/'
  md5 '957bca85de744a9ddd316fd85e882b40'

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
    system "cmake .. #{std_cmake_parameters} -DCMAKE_PREFIX_PATH=#{gettext.prefix}"
    system "make install"
  end

  def patches
    { :p4 => "http://websvn.kde.org/branches/KDE/4.4/kdelibs/plasma/private/applethandle_p.h?r1=1095725&r2=1095724&pathrev=1095725&view=patch" }
  end
end
