require 'brewkit'

class Automoc4 <Formula
  @url='http://ftp-stud.fht-esslingen.de/Mirrors/ftp.kde.org/pub/kde/stable/automoc4/0.9.88/automoc4-0.9.88.tar.bz2'
  @homepage='http://techbase.kde.org/Development/Tools/Automoc4'
  @md5='91bf517cb940109180ecd07bc90c69ec'

  depends_on 'cmake'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
