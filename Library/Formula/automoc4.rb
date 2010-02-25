require 'formula'

class Automoc4 <Formula
  @url='ftp://ftp.kde.org/pub/kde/stable/automoc4/0.9.88/automoc4-0.9.88.tar.bz2'
  @homepage='http://techbase.kde.org/Development/Tools/Automoc4'
  @md5='91bf517cb940109180ecd07bc90c69ec'

  depends_on 'cmake'
  depends_on 'qt'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
