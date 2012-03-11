require 'base_kde_formula'

class Kdelibs < BaseKdeFormula
  homepage 'http://www.kde.org/'
  url 'ftp://ftp.kde.org/pub/kde/stable/4.8.1/src/kdelibs-4.8.1.tar.xz'
  sha1 'da4e13f63ac340619351e9a2f4211cce8ec4fdf8'

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
  
  def extra_cmake_args
    "-DWITH_ENCHANT=ON -DWITH_Soprano=ON -DWITH_Avahi=OFF -DWITH_HSPELL=OFF -DWITH_FAM=OFF"
  end

  def install
    opoo "Compile qt formula first with: --with-qtdbus and --with-qt3support flags."
    puts <<-EOS.undent
      Enable QtDBus module (--with-qtdbus) and Qt3Support module (--with-qt3support)
      in qt formula first to avoid errors in kdevplatform and kdevelop formulas.
    EOS
    default_install
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
