require 'formula'

class Cppdb < Formula
  homepage 'http://cppcms.com/sql/cppdb/'
  url 'http://downloads.sourceforge.net/project/cppcms/cppdb/0.3.1/cppdb-0.3.1.tar.bz2'
  sha1 'c0410dcc482d71696ac9206044b3a3ac03d31f96'

  depends_on 'cmake' => :build
  depends_on 'sqlite' => :optional
  depends_on 'unixodbc'  # If CppDb tries to build against the OS X packaged version of ODBC, it fails

  option 'disable-sqlite', "Don't build sqlite3 backend even if the library was found"
  option 'sqlite-backend-internal', "Don't build a separate sqlite3 loadable module but rather build it into the cppdb library itself"
  option 'disable-mysql', "Don't build mysql backend even if the mysqlclient library was found"
  option 'mysql-backend-internal', "Don't build a separate mysql loadable module but rather build it into the cppdb library itself"
  option 'disable-pq', "Don't build postgresql backend even if the libpq library was found"
  option 'pq-backend-internal', "Don't build a separate postgresql loadable module but rather build it into the cppdb library itself"
  option 'disable-odbc', "Don't build odbc backend even if the odbc library was found"
  option 'odbc-backend-internal', "Don't build a separate odbc loadable module but rather build it into the cppdb library itself"

  def install
    args = std_cmake_args

    args << "-DDISABLE_SQLITE=ON" if build.include? 'disable-sqlite'
    args << "-DSQLITE_BACKEND_INTERNAL=ON" if build.include? 'sqlite-backend-internal'
    args << "-DDISABLE_MYSQL=ON" if build.include? 'disable-mysql'
    args << "-DMYSQL_BACKEND_INTERNAL=ON" if build.include? 'mysql-backend-internal'
    args << "-DDISABLE_PQ=ON" if build.include? 'disable-pq'
    args << "-DPQ_BACKEND_INTERNAL=ON" if build.include? 'pq-backend-internal'
    args << "-DDISABLE_ODBC=ON" if build.include? 'disable-odbc'
    args << "-DODBC_BACKEND_INTERNAL=ON" if build.include? 'odbc-backend-internal'

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end
end
