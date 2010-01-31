require 'formula'

class Attica <Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/attica/attica-0.1.2.tar.bz2'
  homepage 'http://www.kde.org/'
  md5 '8b4207dbc0a826d422632bdb9c50d51a'

  depends_on 'cmake'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
