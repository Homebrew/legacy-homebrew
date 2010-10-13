require 'formula'

class PgpoolIi <Formula
  url 'http://pgfoundry.org/frs/download.php/2798/pgpool-II-3.0.tar.gz'
  homepage 'http://pgpool.projects.postgresql.org/'
  md5 'd93a896ce185bff7920d4b603a4e9111'

  def install
     if `/usr/bin/which pg_config`.chomp.empty?
      opoo "No PostgreSQL was detected."
      puts <<-EOS.undent
        This formula uses `pg_config` to detect an installed PostgreSQL instead
        of "depends_on 'postgresql'" so you can use a non-Homebrew version.
        You may want to `brew install postgresql` if you don't have another
        version already installed.
      EOS
    end

    system "./configure", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end
