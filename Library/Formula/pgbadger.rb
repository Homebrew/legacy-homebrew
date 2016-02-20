class Pgbadger < Formula
  desc "Log analyzer for PostgreSQL"
  homepage "https://dalibo.github.io/pgbadger/"
  url "https://github.com/dalibo/pgbadger/archive/v7.1.tar.gz"
  sha256 "de7f36cb55d2c177fdf47115f3fb5c2e842b443432631212e408726baacbad7e"

  head "https://github.com/dalibo/pgbadger.git"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "98e5d1fef55e72aa177dd544fa2473c8ffb215cb00ccd303dbbff6e59a14c2c3" => :el_capitan
    sha256 "ffc6d23b147f99fec542849b5a96b9e948671fd42019fc57dbba64f1142bbfdf" => :yosemite
    sha256 "777551f41099eea6873574a8ffb54e9919ee7b5e4ab15aacd0c053fda621223d" => :mavericks
  end

  def install
    system "perl", "Makefile.PL", "DESTDIR=#{buildpath}"
    system "make"
    system "make", "install"

    bin.install "usr/local/bin/pgbadger"
    man1.install "usr/local/share/man/man1/pgbadger.1p"
    chmod 0755, bin+"pgbadger" # has 555 by default
    chmod 0644, man1+"pgbadger.1p" # has 444 by default
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

  test do
    (testpath/"server.log").write <<-EOS.undent
      LOG:  autovacuum launcher started
      LOG:  database system is ready to accept connections
    EOS
    system bin/"pgbadger", "-f", "syslog", "server.log"
    assert File.exist? "out.html"
  end
end
