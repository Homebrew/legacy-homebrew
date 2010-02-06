require 'formula'

class Akonadi <Formula
  url 'http://download.akonadi-project.org/akonadi-1.3.0.tar.bz2'
  homepage 'http://pim.kde.org/akonadi/'
  md5 '45fe59bd301268149cb0313d54a98520'

  depends_on 'cmake'
  depends_on 'shared-mime-info'
  depends_on 'mysql'
  depends_on 'automoc4'
  depends_on 'soprano'
  depends_on 'boost'
  depends_on 'qt'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
