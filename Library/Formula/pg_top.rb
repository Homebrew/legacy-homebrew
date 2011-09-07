require 'formula'

class PgTop < Formula
  url 'http://pgfoundry.org/frs/download.php/1781/pg_top-3.6.2.tar.gz'
  homepage 'http://ptop.projects.postgresql.org/'
  md5 '12ddb50cf83e3027d182a1381d388f1d'

  def install
    unless `/usr/bin/which pg_config`.size > 0
      opoo "No pg_config was detected."
      puts <<-EOS.undent
        pg_top requires postgresql in order to compile, but pg_config was not
        found. This install will likely fail.

        You can install this with:
          brew install postgresql
        or by using a package installer from the PostgreSQL project itself.
      EOS
    end

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
