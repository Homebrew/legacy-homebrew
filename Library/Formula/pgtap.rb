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

class Pgtap < Formula
  url 'http://pgfoundry.org/frs/download.php/2701/pgtap-0.24.tar.bz2'
  homepage 'http://pgtap.org'
  sha1 '8a23fe62e1e476731076a588cb628fe9f1a028b1'

  depends_on PostgresqlInstalled.new

  skip_clean :all

  def install
    system "make install"
    bin.install %w(bbin/pg_prove bbin/pg_tapgen)
  end
end
