require 'formula'

class Kdelibs < Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.7.4/src/kdelibs-4.7.4.tar.bz2'
  homepage 'http://www.kde.org/'
  md5 '46baa210a6f5a0d6af4b7602a4b00994'

  depends_on 'cmake' => :build
  depends_on 'automoc4' => :build
  depends_on 'gettext'
  depends_on 'pcre'
  depends_on 'jpeg'
  depends_on 'giflib'
  depends_on 'strigi'
  depends_on 'soprano'
  depends_on 'shared-desktop-ontologies'
  depends_on 'shared-mime-info'
  depends_on 'attica'
  depends_on 'docbook'
  depends_on 'd-bus'
  depends_on 'qt'
  depends_on 'libdbusmenu-qt'

  def install
    ENV.x11
    gettext_prefix = Formula.factory('gettext').prefix
    docbook_prefix = Formula.factory('docbook').prefix
    docbook_dtd = "#{docbook_prefix}/docbook/xml/4.5"
    docbook_xsl = Dir.glob("#{docbook_prefix}/docbook/xsl/*").first
    mkdir 'build'
    cd 'build'
    system "cmake .. #{std_cmake_parameters} -DCMAKE_PREFIX_PATH=#{gettext_prefix} -DDOCBOOKXML_CURRENTDTD_DIR=#{docbook_dtd} -DDOCBOOKXSL_DIR=#{docbook_xsl} -DBUILD_doc=FALSE -DBUNDLE_INSTALL_DIR=#{bin}"
    system "make install"
  end
end
