require 'formula'

class Akonadi <Formula
  url 'http://download.akonadi-project.org/akonadi-1.3.1.tar.bz2'
  homepage 'http://pim.kde.org/akonadi/'
  md5 'e6eef3ed5c28d55f4b6530544e379413'

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
