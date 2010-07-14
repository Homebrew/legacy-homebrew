require 'formula'

class Kdepim <Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/4.4.2/src/kdepim-4.4.2.tar.bz2'
  homepage ''
  md5 'db74243fb2192b64bb613027e1c0cc23'

  depends_on 'cmake'
  depends_on 'kdebase-runtime'

  def install
    system "cmake . #{std_cmake_parameters} -DBUNDLE_INSTALL_DIR=#{bin}"
    system "make install"
  end
end
