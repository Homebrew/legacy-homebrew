require 'formula'

class Akonadi <Formula
  url 'http://download.akonadi-project.org/akonadi-1.4.0.tar.bz2'
  homepage 'http://pim.kde.org/akonadi/'
  md5 'ed19efb982f7debd7e109cf1397d0588'

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
