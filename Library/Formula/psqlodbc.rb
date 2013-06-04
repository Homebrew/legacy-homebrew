require 'formula'

class Psqlodbc < Formula
  homepage 'http://psqlodbc.projects.pgfoundry.org/'
  url 'http://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-09.01.0200.tar.gz'
  sha1 '9ecee7c370ec6a0d87791490dea01723436a4e2b'

  option 'with-iodbc', "Build using iODBC instead of unixODBC."
  option 'disable-unicode', "Build without Unicode support"

  depends_on :postgresql
  
  unless build.include? 'with-iodbc'
    depends_on "unixodbc"
  else
    depends_on "libiodbc"
  end
  
  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}", "--enable-pthreads"]

    unless build.include?("with-iodbc")
      args << "--with-unixodbc=#{Formula.factory('unixodbc').prefix}"
    else
      args << "--with-iodbc=#{Formula.factory('libiodbc').prefix}"
    end

    if build.include? "disable-unicode"
      args << "--disable-unicode"
    end

    system "./configure", *args

    system "make"
    system "make", "install"
  end
end
