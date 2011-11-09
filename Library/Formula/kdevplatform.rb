require 'formula'

class Kdevplatform < Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/kdevelop/4.2.3/src/kdevplatform-1.2.3.tar.bz2'
  homepage 'http://kdevelop.org'
  md5 '2b1c36cf02f30351e5fb62dd945e3408'

  depends_on 'cmake' => :build
  depends_on 'kdelibs'
  depends_on 'boost' => :optional
  depends_on 'qjson' => :optional

  def install
    ENV.x11
    gettext_prefix = Formula.factory('gettext').prefix
    mkdir 'build'
    cd 'build'
    system "cmake .. #{std_cmake_parameters} -DCMAKE_PREFIX_PATH=#{gettext_prefix} -DBUNDLE_INSTALL_DIR=#{bin}"
    system "make install"
  end
end
