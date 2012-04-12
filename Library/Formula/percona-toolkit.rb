require 'formula'

class PerconaToolkit < Formula
  homepage 'http://www.percona.com/software/percona-toolkit/'
  url 'http://www.percona.com/redir/downloads/percona-toolkit/2.1.1/percona-toolkit-2.1.1.tar.gz'
  md5 '14be6a3e31c7b20aeca78e3e0aed6edc'

  depends_on 'Time::HiRes' => :perl
  depends_on 'DBD::mysql' => :perl

  def install
    system "perl Makefile.PL PREFIX=#{prefix}"
    system "make"
    system "make test"
    system "make install"
  end

  def test
    system "pt-archiver"
    system "pt-config-diff"
    system "pt-deadlock-logger"
    system "pt-duplicate-key-checker"
    system "pt-find"
    system "pt-fk-error-logger"
    system "pt-heartbeat"
    system "pt-kill"
    system "pt-log-player"
    system "pt-pmp"
    system "pt-slave-delay"
    system "pt-slave-find"
    system "pt-slave-restart"
    system "pt-summary"
    system "pt-table-checksum"
    system "pt-table-sync"
    system "pt-upgrade"
    system "pt-variable-advisor"
  end
end
