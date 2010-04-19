require 'formula'

class OxygenIcons <Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.4.2/src/oxygen-icons-4.4.2.tar.bz2'
  homepage 'http://www.oxygen-icons.org/'
  md5 '86e655d909f743cea6a2fc6dd90f0e52'

  depends_on 'cmake'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
