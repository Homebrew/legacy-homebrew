require 'formula'

class PostgresqlInstalled < Requirement
  def message; <<-EOS.undent
    PostgresQL is required to install.

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

class PgpoolIi < Formula
  homepage 'http://pgpool.projects.postgresql.org/'
  url 'http://pgfoundry.org/frs/download.php/2841/pgpool-II-3.0.1.tar.gz'
  md5 '86d8beff0396d11b6753dd2be31bcad7'

  depends_on PostgresqlInstalled.new

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
