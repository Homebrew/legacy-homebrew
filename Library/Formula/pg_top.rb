require 'formula'

class PostgresqlInstalled < Requirement
  def message; <<-EOS.undent
    PostgreSQL is required to install.

    You can install this with:
      brew install postgresql

    Or you can use an official installer from:
      http://www.postgresql.org/
    EOS
  end
  def satisfied?
    which 'pg_config'
  end
  def fatal?
    true
  end
end


class PgTop < Formula
  homepage 'http://ptop.projects.postgresql.org/'
  url 'http://pgfoundry.org/frs/download.php/1781/pg_top-3.6.2.tar.gz'
  sha1 'c165a5b09ab961bf98892db94b307e31ac0cf832'

  depends_on PostgresqlInstalled.new

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
