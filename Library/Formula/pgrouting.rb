require 'formula'
 
class Pgrouting < Formula
  homepage 'http://www.pgrouting.org/index.html'
  url 'http://download.osgeo.org/pgrouting/source/pgrouting-1.05.tar.gz'
  sha1 '582b37eebf86416ca8936e2f3992b5319abc5325'
 
  option 'tsp', 'Build with Traveling Salesperson Problem support using gaul'
  option 'dd', 'Build with Driving Distance support using cgal'
 
  depends_on 'cmake' => :build
  depends_on 'postgis'
  depends_on 'boost149'
  depends_on 'cgal' if build.include? 'dd'
  depends_on 'gaul' if build.include? 'tsp'
 
  def patches
    [
      'https://github.com/pgRouting/pgrouting/commit/8574864fcce8f37acabe40b985b36c6c3e8c7bdd.patch',
      'https://github.com/pgRouting/pgrouting/commit/27e5ccd4da4f8ddd2b7b59c5a10e03d93eeb766b.patch',
      'https://github.com/pgRouting/pgrouting/commit/dc6bff6b6923a565986eb4e314351299dc101f9a.patch',
      'https://github.com/pgRouting/pgrouting/commit/1be144ec4cc11f9748eca881a44668a4bdf3343b.patch',
      'https://github.com/pgRouting/pgrouting/commit/6111c065bf8020bfdee7c36c0e25beed1146695a.patch'
    ]
  end

  def install
    inreplace 'CMakeLists.txt',
      "SET(SQL_INSTALL_PATH /usr/share/postlbs)",
      "SET(SQL_INSTALL_PATH #{share}/pgrouting)"
    mkdir 'brewery' do
      ENV.j1
      args = std_cmake_args
      args << '-DPOSTGRESQL_INCLUDE_DIR=' + %x(pg_config --includedir-server).chomp
      args << '-DPOSTGRESQL_LIBRARIES=' + %x(pg_config --pkglibdir).chomp
      args << '-DWITH_TSP=ON' if build.include? 'tsp'
      args << '-DWITH_DD=ON' if build.include? 'dd'
      args << "-DBoost_INCLUDE_DIR='#{Formula.factory('boost149').prefix}/include'"
      args << '..'
      system 'cmake', *args
      system 'make'
      system 'make install'
    end
  end
end
