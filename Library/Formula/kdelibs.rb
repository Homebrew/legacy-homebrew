require 'formula'

class Kdelibs <Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.4.2/src/kdelibs-4.4.2.tar.bz2'
  homepage 'http://www.kde.org/'
  md5 '44ddba0e31ee3d78da09f0176d3c66db'

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
  depends_on 'shared-mime-info'
  depends_on 'attica'

  depends_on 'libpng' unless File.exist? "/usr/X11R6/lib"

  def install
    gettext = Formula.factory 'gettext'
    FileUtils.mkdir('build')
    FileUtils.cd('build')
    system "cmake .. #{std_cmake_parameters} -DCMAKE_PREFIX_PATH=#{gettext.prefix} -DBUNDLE_INSTALL_DIR=#{bin}"
    system "make install"
  end

  def caveats
    <<-END_CAVEATS
    WARNING: this doesn't actually work for running KDE applications yet!

    Please don't just add the Macports patches and expect them to be pulled.
    I'm avoiding adding patches that haven't been committed to KDE upstream
    (which I have commit access to). Instead of requesting I add these,
    consider writing and testing an upstream-suitable patch.

    Thanks for your patience!
    END_CAVEATS
  end
end
