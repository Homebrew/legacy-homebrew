require 'formula'

class OxygenIcons <Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.4.0/src/oxygen-icons-4.4.0.tar.bz2'
  homepage 'http://www.oxygen-icons.org/'
  md5 'fbcd429cc822cb88a815d97a4e66be4d'

  depends_on 'cmake'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
