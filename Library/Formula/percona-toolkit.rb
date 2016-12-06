require 'formula'

class PerconaToolkit < Formula
  url 'http://www.percona.com/redir/downloads/percona-toolkit/percona-toolkit-1.0.1.tar.gz'
  homepage 'http://www.percona.com/software/percona-toolkit/'
  md5 '1d843b1b3ebd2eacfa3bf95ef2a00557'

  def install
    # Copy the prebuilt binaries to prefix
    prefix.install Dir['*']
  end

	def caveats; <<-EOS.undent
    For some command you need to install "DBD::mysql" perl module
    EOS
  end

  def test
    system "pt-archiver"
	# system "pt-collect"
	system "pt-config-diff"
	system "pt-deadlock-logger"
	# system "pt-diskstats"
	# system "pt-duplicate-key-checker"
	# system "pt-fifo-split"
	# system "pt-find"
	system "pt-fk-error-logger"
	system "pt-heartbeat"
	# system "pt-index-usage"
	system "pt-kill"
	system "pt-log-player"
	# system "pt-mext"
	# system "pt-mysql-summary"
	# system "pt-online-schema-change"
	system "pt-pmp"
	# system "pt-query-advisor"
	# system "pt-query-digest"
	# system "pt-show-grants"
	# system "pt-sift"
	system "pt-slave-delay"
	system "pt-slave-find"
	# system "pt-slave-restart"
	# system "pt-stalk"
	system "pt-summary"
	system "pt-table-checksum"
	system "pt-table-sync"
	# system "pt-tcp-model"
	# system "pt-trend"
	system "pt-upgrade"
	system "pt-variable-advisor"
	# system "pt-visual-explain"
  end
end
