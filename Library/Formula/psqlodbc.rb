require 'formula'

class Psqlodbc < Formula
  homepage 'http://psqlodbc.projects.pgfoundry.org/'
  url 'http://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-09.01.0200.tar.gz'
  sha1 '9ecee7c370ec6a0d87791490dea01723436a4e2b'

  option 'with-unixodbc', "Whether unixODBC driver manager is used"
  option 'with-iodbc', "Whether iDOCB driver manager is used"
  option 'disable-unicode', "Build without Unicode support"

  depends_on "unixodbc" if build.with? "unixodbc"
  depends_on "libiodbc" if build.with? "iodbc"

  def install
    args = ["--disable-dependency-tracking", "--prefix=#{prefix}", "--enable-pthreads"]

    if build.include? "disable-unicode"
      args << "--disable-unicode"
    end

    if build.with? "iodbc"
      args << "--with-iodbc=#{Formula.factory('libiodbc').prefix}"
    end

    if build.with? "unixodbc"
      args << "--with-unixodbc=#{Formula.factory('unixodbc').prefix}"
    end

    system "./configure", *args

    system "make"
    system "make", "install"
  end
end
