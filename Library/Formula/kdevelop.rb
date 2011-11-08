require 'formula'

class Kdevelop < Formula
  url 'ftp://ftp.kde.org/pub/kde/stable/kdevelop/4.2.3/src/kdevelop-4.2.3.tar.bz2'
  homepage 'http://kdevelop.org'
  md5 '8b6e59764612314e6776edb3386c0930'

  depends_on 'cmake' => :build
  depends_on 'kdevplatform'
  depends_on 'kate'

  def install
    ENV.x11
    gettext_prefix = Formula.factory('gettext').prefix
    mkdir 'build'
    cd 'build'
    system "cmake .. #{std_cmake_parameters} -DCMAKE_PREFIX_PATH=#{gettext_prefix} -DBUNDLE_INSTALL_DIR=#{bin}"
    system "make install"
  end

  def caveats; <<-EOS.undent
    Remember to run brew linkapps.
    EOS
  end
end
