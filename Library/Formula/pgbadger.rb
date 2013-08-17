require 'formula'

class Pgbadger < Formula
  homepage 'http://dalibo.github.io/pgbadger/'
  url 'http://downloads.sourceforge.net/project/pgbadger/3.5/pgbadger-3.5.tar.gz'
  sha1 '57e9351819c18ba137f5b7ab533168e396681ae6'

  def install
    system "perl", "Makefile.PL", "DESTDIR=."
    system "make"
    system "make install"
    bin.install "usr/local/bin/pgbadger"
    man1.install "usr/local/share/man/man1/pgbadger.1"
    chmod 0755, bin+'pgbadger' # has 555 by default
    chmod 0644, man1+'pgbadger.1' # has 444 by default
  end

  def caveats; <<-EOS.undent
    You must configure your PostgreSQL server before using pgBadger.
    Edit postgresql.conf (in #{var}/postgres if you use Homebrew's
    PostgreSQL), set the following parameters, and restart PostgreSQL:

      log_destination = 'stderr'
      log_line_prefix = '%t [%p]: [%l-1] user=%u,db=%d '
      log_statement = 'none'
      log_duration = off
      log_min_duration_statement = 0
      log_checkpoints = on
      log_connections = on
      log_disconnections = on
      log_lock_waits = on
      log_temp_files = 0
      lc_messages = 'C'
    EOS
  end
end
