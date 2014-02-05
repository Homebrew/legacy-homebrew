require "formula"

class Psqlodbc < Formula
  depends_on 'unixodbc'

  homepage ""
  url "http://ftp.postgresql.org/pub/odbc/versions/src/psqlodbc-09.03.0100.tar.gz"
  sha1 "3f6949687f412ca9f7ba740ffc0c06d7afa9b16a"

  depends_on :x11

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-unixodbc=/usr/local/bin/odbc_config"
    
    system "make"
    system "make install"
  end

end
