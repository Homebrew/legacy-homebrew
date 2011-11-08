require 'formula'

class Kdelibs < Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.7.3/src/kdelibs-4.7.3.tar.bz2'
  homepage 'http://www.kde.org/'
  md5 '57fdc211995a6846b15dfdbf40a3e2e3'

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
  depends_on 'aspell' => :optional
  depends_on 'enchant' => :optional

  def patches
    # macports patches.
    {:p1 => [
      "http://svn.macports.org/repository/macports/trunk/dports/kde/kdelibs4/files/add-bundles-to-path.patch",
      "http://svn.macports.org/repository/macports/trunk/dports/kde/kdelibs4/files/default-kde4-xdg-menu-prefix.patch",
      "http://svn.macports.org/repository/macports/trunk/dports/kde/kdelibs4/files/workaround-kdeinit4-crash.patch",
      "http://svn.macports.org/repository/macports/trunk/dports/kde/kdelibs4/files/patch-cmake-modules-FindKDE4-Internal.cmake.diff",
      "http://svn.macports.org/repository/macports/trunk/dports/kde/kdelibs4/files/patch-cmake-modules-FindPhonon.cmake.diff",
      "http://svn.macports.org/repository/macports/trunk/dports/kde/kdelibs4/files/patch-cmake-modules-FindQt4.cmake.diff"
    ]}
  end

  def install
    opoo "Compile qt formula first with: --with-qtdbus and --with-qt3support flags."
    puts <<-EOS.undent
      Enable QtDBus module (--with-qtdbus) and Qt3Support module (--with-qt3support)
      in qt formula first to avoid errors in kdevplatform and kdevelop formulas.
    EOS

    ENV.x11
    gettext_prefix = Formula.factory('gettext').prefix
    docbook_prefix = Formula.factory('docbook').prefix
    docbook_dtd = "#{docbook_prefix}/docbook/xml/4.5"
    docbook_xsl = Dir.glob("#{docbook_prefix}/docbook/xsl/*").first
    args = std_cmake_parameters.split + [
      "-DCMAKE_PREFIX_PATH=#{gettext_prefix}",
      "-DDOCBOOKXML_CURRENTDTD_DIR=#{docbook_dtd}",
      "-DDOCBOOKXSL_DIR=#{docbook_xsl}",
      "-DBUILD_doc=FALSE",
      "-DBUNDLE_INSTALL_DIR=#{bin}",
      "-DWITH_ENCHANT=ON",
      "-DWITH_Soprano=ON",
      "-DKDE_DEFAULT_HOME=Library/Preferences/KDE",
      "-DWITH_Avahi=OFF",
      "-DWITH_HSPELL=OFF",
      "-DWITH_FAM=OFF"]
    mkdir "build"
    cd "build"
    args << ".."
    system "cmake", *args
    system "make install"
  end

  def caveats; <<-EOS.undent
      First add /usr/local path to your $KDEDIRS in your ~/.bash_profile file.
        export KDEDIRS="$KDEDIRS:$HOME/Library/Preferences/KDE:/usr/local"

      Now remember to run kbuildsycoca4 command, if you have some issues with kdevelop
      formula or kate formula about mime types, try to update mime types:
        $ update-mime-database /usr/local/share/mime
        $ kbuildsycoca4 --noincremental
    EOS
  end
end
