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
  homepage 'http://www.pgpool.net/mediawiki/index.php/Main_Page'
  url 'http://pgfoundry.org/frs/download.php/2841/pgpool-II-3.0.7.tar.gz'
  sha1 '1c72a271d65bd7b44b473b5020746808a056bf3d'

  depends_on PostgresqlInstalled.new

  def install
    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
