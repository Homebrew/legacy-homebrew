require 'formula'

class Pgrouting < Formula
  url 'http://download.osgeo.org/pgrouting/source/pgrouting-1.05.tar.gz'
  homepage 'http://www.pgrouting.org/'
  md5 'bd7c106e3db3c38f7081f1ee9b0e12ae'
  version '1.05'

  depends_on "cmake"
  depends_on "postgresql"
  depends_on "postgis"
  depends_on "boost"
  depends_on "proj"
  depends_on "geos"
  depends_on "gaul"

  def install
    # Copy generated SQL files to the share folder
    pgrouting_sql = share + 'postlbs'

    system "cmake . #{std_cmake_parameters} -DPOSTGRESQL_INCLUDE_DIR='#{Formula.factory('postgresql').prefix}/include/server/' -DPOSTGRESQL_LIBRARIES='#{Formula.factory('postgresql').prefix}' -DBoost_INCLUDE_DIR='#{Formula.factory('boost').prefix}/include/boost/' -DSQL_INSTALL_PATH='#{pgrouting_sql}'"
    system "make"
    system "make install"
  end

  def patches
    # fixes various issues to make compilation possible on Mac Os X
    "https://gist.github.com/raw/1271301/c65876cb798647c15e641835370ecb2bcefa8e0c/pgrouting-mac-os-x.patch"
  end
end
