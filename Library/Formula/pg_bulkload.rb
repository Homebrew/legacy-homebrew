require 'formula'

class PgBulkload <Formula
  url 'http://pgfoundry.org/frs/download.php/2906/pg_bulkload-3.0.1.tar.gz'
  homepage 'http://pgbulkload.projects.postgresql.org/'
  md5 '1903498b38124b8c23ec6faa1b8e79ba'

  depends_on 'postgresql'

  def install
    system "make USE_PGXS=1 install"
    bin.install `pg_config --bindir`.rstrip + '/pg_bulkload'
  end

  def caveats
    return <<-EOS
To register pg_bulkload with a database, make sure that your server is running,
then type:

    psql -f `pg_config --sharedir`/contrib/pg_bulkload.sql database_name

EOS
  end
end
