require 'formula'

class Psqlodbc < Formula
  homepage 'http://www.postgresql.org/'
  url 'http://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-09.03.0210.tar.gz'
  sha1 'e1eb147ef0452e1f7b0f9e102dacb5654a580dba'

  option 'with-osxserverpsql', 'Compile with OS X Server PostgreSQL'

  depends_on 'unixodbc'
  depends_on 'postgresql' if build.without? 'osxserverpsql'

  def install
    args = %W[
      --prefix=#{prefix}
      --with-unixodbc=#{Formula.factory('unixodbc').prefix}
    ]

    if build.with? 'osxserverpsql'
      args << "--with-libpq=/Applications/Server.app/Contents/ServerRoot/usr"
    end

    system "./configure", *args
    system "make"
    system "make", "install"
  end
end
