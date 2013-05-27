require 'formula'

class Psqlodbc < Formula
  homepage 'http://www.postgresql.org/'
  url 'http://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-09.01.0200.tar.gz'
  sha1 '9ecee7c370ec6a0d87791490dea01723436a4e2b'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"

    system "make"
    system "make", "install"
  end
end
