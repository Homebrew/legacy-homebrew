require 'formula'

class Akonadi <Formula
  url 'http://download.akonadi-project.org/akonadi-1.5.0.tar.bz2'
  homepage 'http://pim.kde.org/akonadi/'
  md5 '8b0d43b0e947b876a461d90f4b877f54'

  depends_on 'cmake' => :build
  depends_on 'automoc4' => :build
  depends_on 'shared-mime-info'
  depends_on 'mysql'
  depends_on 'soprano'
  depends_on 'boost'
  depends_on 'qt'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
