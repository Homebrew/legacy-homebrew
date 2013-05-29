require 'formula'

class Psqlodbc < Formula
  homepage 'http://psqlodbc.projects.pgfoundry.org/'
  url 'http://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-09.01.0200.tar.gz'
  sha1 '9ecee7c370ec6a0d87791490dea01723436a4e2b'
  
  depends_on "postgresql"
  depends_on "unixodbc" => :optional
  depends_on "libiodbc" => [:optional, 'with-iodbc']

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}", "--enable-pthreads"]
    args << "--with-libpq=#{Formula.factory('postgresql').lib}"
    
    if build.include? "disable-unicode"
      args << "--disable-unicode"
    end
    
    if build.include? "with-iodbc"
      args << "--with-iodbc=#{Formula.factory('libiodbc').prefix}"
    end
    if build.include? "with-unixodbc"
      args << "--with-unixodbc=#{Formula.factory('unixodbc').prefix}"
    end
    
    system "./configure", *args

    system "make"
    system "make", "install"
  end
end
