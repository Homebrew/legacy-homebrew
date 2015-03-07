require "formula"

class Pgbadger < Formula
  homepage "http://dalibo.github.io/pgbadger/"
  url "https://downloads.sourceforge.net/project/pgbadger/6.2/pgbadger-6.2.tar.gz"
  sha1 "46f6935ff746f8b2002009ebbcae60d23aaff8b3"

  bottle do
    cellar :any
    sha1 "9616da60ee7c521b8f03e747ac7ec558059be8ed" => :yosemite
    sha1 "41b734655e5c158be3e585e8108b8cab67017004" => :mavericks
    sha1 "029768bd3f29fc116c531bc16edc42fb77c30ff7" => :mountain_lion
  end

  def install
    system "perl", "Makefile.PL", "DESTDIR=."
    system "make"
    system "make install"
    bin.install "usr/local/bin/pgbadger"
    man1.install "usr/local/share/man/man1/pgbadger.1"
    chmod 0755, bin+"pgbadger" # has 555 by default
    chmod 0644, man1+"pgbadger.1" # has 444 by default
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
